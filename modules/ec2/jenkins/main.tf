
########################################
##CREATE ROLE IAM FOR jenkins INSTANCE##
########################################
resource "aws_iam_role" "jenkins_role" {
  name               = "${var.project}-${var.jenkins_application}-${var.env}"
  assume_role_policy = file("${path.module}/iam_jenkins_role.json")
}
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.project}-${var.jenkins_application}-${var.env}"
  role = aws_iam_role.jenkins_role.name
}
###############################################
##CREATE POLICY IAM FOR ROLE jenkins INSTANCE##
###############################################
resource "aws_iam_policy" "jenkins_policy" {
  name        = "${var.project}-${var.jenkins_application}-${var.env}"
  description = "A Jenkins policy"
  policy      = file("${path.module}/iam_jenkins_policy.json")
}
resource "aws_iam_policy_attachment" "bation_attach" {
  name       = "${var.project}-${var.jenkins_application}-${var.env}"
  roles      = ["${aws_iam_role.jenkins_role.name}"]
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

#################################
##IDENTIFIED THE USER-DATA FILE##
#################################
data "template_file" "userdata" {
  template = file("${path.module}/${var.jenkins_userdata}")
}
##############################
#CREATE EC2 INSTANCE jenkins##
##############################
module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"
  name    = "${var.jenkins_application}"

  instance_count              = "${var.jenkins_instance_count}"
  ami                         = "ami-00514a528eadbc95b" #"${data.aws_ami.amazon.id}"
  instance_type               = "${var.jenkins_instance_type}"
  key_name                    = "${var.project}-${var.env}"
  monitoring                  = "${var.jenkins_monitoring}"
  user_data                   = "${data.template_file.userdata.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.jenkins_profile.name}"
  vpc_security_group_ids      = ["${var.sg_jenkins}", "${var.sg_internal_ssh}"]
  subnet_id                   = var.private_subnet_ids[2]
  root_block_device           = [{
    volume_size = "${var.jenkins_ebs_root_size}"
  }]
########
##TAGS##
########
  volume_tags= {
    Name        = "${var.jenkins_application}"
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
  tags = {
    Name        = "${var.jenkins_application}"
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
}

#########################
## CREATE TARGET GROUP ##
#########################
resource "aws_lb_target_group" "tg_jenkins" {
  name        = "TG-${var.jenkins_application}-${var.project}-${var.env}"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    protocol            = var.hc_protocol
    path                = var.jenkins_hc_path
    port                = var.hc_port
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.hc_timeout
    interval            = var.hc_interval
    matcher             = var.hc_matcher
  }
  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    enabled         = var.stickiness_enabled
  }
  tags = {
    Name        = "TG-${var.jenkins_application}-${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.tg_jenkins.arn
  target_id        = module.ec2_cluster.id[0]
  port             = "80"
}

#############################################
## CREATE ALB LISTENER RULE TO JENKINS ALB ##
#############################################

resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = var.api_listener_ssl
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_jenkins.arn
  }

  condition {
    host_header {
      values = [ "jenkins.witadvisor.com" ]
    }
  }
}