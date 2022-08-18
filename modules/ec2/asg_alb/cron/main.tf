################################
##CREATE ROLE IAM FOR INSTANCE##
#################################
resource "aws_iam_role" "app_role" {
  name               = "asg-${var.project}-${var.application}-${var.env}"
  assume_role_policy = file("${path.module}/iam-role-app.json")
}
resource "aws_iam_instance_profile" "app_profile" {
  name = "asg-${var.project}-${var.application}-${var.env}"
  role = aws_iam_role.app_role.name
}

##############################################
##CREATE POLICY IAM FOR ROLE app INSTANCE##
##############################################
resource "aws_iam_policy" "app_policy" {
  name        = "asg-${var.project}-${var.application}-${var.env}"
  description = "A app policy"
  policy      = file("${path.module}/iam-policy-app.json")
}
resource "aws_iam_policy_attachment" "app_attach" {
  name       = "asg-attachment-${var.project}-${var.application}-${var.env}"
  roles      = [aws_iam_role.app_role.name]
  policy_arn = aws_iam_policy.app_policy.arn
}
###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################

resource "aws_security_group" "app" {
  name        = "sg_${var.project}-${var.application}-${var.env}"
  description = "Allow ssh inbound traffic VPC only"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_${var.project}-${var.application}-${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Terraform   = "${var.terraform}"
  }
}


#################################
## CREATE LAUNCH CONFIGURATION ##
#################################
data "aws_ami" "app-ami" {
  most_recent = true
  owners = ["self"]
  filter {                       
    name = "tag:Release"     
    values = ["Latest"]
  }                              
}
output "ami_id" {
  value = data.aws_ami.app-ami.id
}
resource "aws_launch_configuration" "as_conf" {
  name_prefix           = "LC-${var.project}-${var.application}-${var.env}"
  image_id              = data.aws_ami.app-ami.id
  instance_type         = var.cron_instance_type
  user_data             = file("${path.module}/userdata.sh")
  iam_instance_profile  = aws_iam_instance_profile.app_profile.name
  key_name              = "${var.project}-${var.env}"
  security_groups       = [var.sg_internal_ssh, aws_security_group.app.id]

  lifecycle {
    create_before_destroy = true
  }
  # Required to redeploy without an outage.
  ebs_optimized         = true
  root_block_device     {
    volume_size = var.cron_ebs_root_size
  }
}
###############################
## CREATE AUTO SCALING GROUP ##
###############################
resource "aws_autoscaling_group" "AutoSG" {
  name                      = "ASG-${var.project}-${var.application}-${var.env}"
  max_size                  = var.cron_max_size
  min_size                  = var.cron_min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  desired_capacity          = var.cron_desired_capacity
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  #target_group_arns         = [var.aws_lb_target_group]
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  enabled_metrics           = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = [
    {
    key                 = "Name"
    value               = "ASG-${var.project}-${var.application}-${var.env}"
    propagate_at_launch = true
    },
    {
    key                 = "Terraform"
    value               = var.terraform
    propagate_at_launch = true
    },
    {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
    },
    {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
    },
    {
    key                 = "Create_by"
    value               = var.creator
    propagate_at_launch = true
    }
  ]
}
