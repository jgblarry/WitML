###########################################
##CREATE SECURITY GROUPS FOR EC2 INSTANCE##
###########################################
resource "aws_security_group" "openvpn" {
  name        = "sg_${var.openvpn_instance_name}"
  description = "Allow ssh inbound traffic VPC only"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_${var.openvpn_instance_name}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Terraform   = "${var.terraform}"
  }
}

resource "aws_security_group" "ssh" {
  name        = "sg_secure_ssh_${var.project}"
  description = "Allow ssh inbound traffic VPC only"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.eip_openvpn.public_ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_secure_ssh_${var.project}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Terraform   = "${var.terraform}"
  }
}

#############
## SSH KEY ##
#############
resource "aws_key_pair" "generated_key" {
  key_name   = "infra-${var.openvpn_instance_name}"
  public_key = file("./modules/ec2/openvpn/openvpn.pub")
}

########################################
##CREATE ROLE IAM FOR OPENVPN INSTANCE##
########################################
resource "aws_iam_role" "openvpn_role" {
  name               = "role-${var.openvpn_instance_name}"
  assume_role_policy = file("./modules/ec2/openvpn/iam_openvpn_role.json")
}
resource "aws_iam_instance_profile" "openvpn_profile" {
  name = "${var.openvpn_instance_name}_profile"
  role = aws_iam_role.openvpn_role.name
}
###############################################
##CREATE POLICY IAM FOR ROLE OPENVPN INSTANCE##
###############################################
resource "aws_iam_policy" "openvpn_policy" {
  name        = "openvpn_policy"
  description = "A Openvpn policy"
  policy      = file("./modules/ec2/openvpn/iam_openvpn_policy.json")
}
resource "aws_iam_policy_attachment" "openvpn_attach" {
  name       = "${var.openvpn_instance_name}_attachment"
  roles      = ["${aws_iam_role.openvpn_role.name}"]
  policy_arn = aws_iam_policy.openvpn_policy.arn
}

#################################
##IDENTIFIED THE USER-DATA FILE##
#################################
data "template_file" "userdata" {
  template = "${file(var.openvpn_userdata)}"
}
##############################
#CREATE EC2 INSTANCE openvpn##
##############################
module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"
  name    = "${var.openvpn_instance_name}"

  instance_count              = "${var.instance_count}"
  ami                         = "ami-00514a528eadbc95b" #"${data.aws_ami.amazon.id}"
  instance_type               = "${var.openvpn_instance_type}"
  key_name                    = aws_key_pair.generated_key.key_name
  monitoring                  = "${var.openvpn_monitoring}"
  user_data                   = "${data.template_file.userdata.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.openvpn_profile.name}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn.id}", "${aws_security_group.ssh.id}"]
  associate_public_ip_address = "${var.openvpn_associate_public_ip_address}"
  subnet_id                   = "${var.public_subnet_ids[2]}"
  source_dest_check           = "${var.openvpn_source_dest_check}"
  root_block_device           = [{
    volume_size = "${var.openvpn_ebs_root_size}"
  }]
########
##TAGS##
########
  volume_tags= {
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
  tags = {
    Terraform   = "${var.terraform}"
    Environment = "${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    BackupDaily = "True"
  }
}

#################################
## DATA SELECTION AWS INSTANCE ##
#################################
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
  owners = ["amazon"] #Canonical
}