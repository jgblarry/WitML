###########################################
##CREATE SECURITY GROUPS FOR EFS SERVICE ##
###########################################
resource "aws_security_group" "efs" {
  name        = "sg_efs_${var.project}-${var.env}"
  description = "Allow inbound traffic VPC only by 2049 port"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_efs_${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}

################
## DEPLOY EFS ##
################
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.project}-${var.env}"

  ###########
  ## TAGS ###
  ###########

tags = {
    Name          = "${var.project}-${var.env}"
    Terraform     = var.terraform
    Environment   = var.env
    Create_by     = var.creator
    Project       = var.project
  }
}
resource "aws_efs_mount_target" "efs_target" {
  file_system_id    = aws_efs_file_system.efs.id
  subnet_id         = var.private_subnet_ids[0]
  security_groups   = [aws_security_group.efs.id]
}
resource "aws_efs_mount_target" "efs_target-b" {
  file_system_id    = aws_efs_file_system.efs.id
  subnet_id         = var.private_subnet_ids[1]
  security_groups   = [aws_security_group.efs.id]
}
resource "aws_efs_mount_target" "efs_target-c" {
  file_system_id    = aws_efs_file_system.efs.id
  subnet_id         = var.private_subnet_ids[2]
  security_groups   = [aws_security_group.efs.id]
}