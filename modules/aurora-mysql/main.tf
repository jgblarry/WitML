#################################
##CREATE AURORA SECURITY GROUPS##
#################################
resource "aws_security_group" "mysql" {
  name        = "sg_aurora_${var.project}-${var.env}"
  description = "Allow inbound traffic VPC only by 3306 port"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_aurora_${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
###############################
# CREATE RDS AURORA DATABASE ##
###############################
module "aurora" {
  source                              = "terraform-aws-modules/rds-aurora/aws"
  name                                = "${var.project}-${var.env}"
  engine                              = var.aurora_engine
  engine_version                      = var.version_engine
  subnets                             = [var.database_subnet_ids[0], var.database_subnet_ids[1]]
  vpc_id                              = var.vpc_id
  allowed_security_groups             = [aws_security_group.mysql.id]
  allowed_cidr_blocks                 = [var.vpc_cidr]
  replica_count                       = var.replica_count
  instance_type                       = var.instance_type

  database_name                       = var.database_name
  username                            = var.username
  password                            = var.password

  apply_immediately                   = true
  skip_final_snapshot                 = true
  db_parameter_group_name             = aws_db_parameter_group.aurora_db_parameter_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  monitoring_interval                 = var.monitoring_interval
  publicly_accessible                 = var.publicly_accessible
  #ca_cert_identifier                  = rds-ca-2019
  #create_security_group               = false

  replica_scale_enabled               = true
  replica_scale_cpu                   = 60
  replica_scale_min                   = 1
  replica_scale_max                   = 5
  tags = {
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}

resource "aws_db_parameter_group" "aurora_db_parameter_group" {
  name        = "${var.project}-${var.env}"
  family      = var.db_family
  description = "aurora-db-57-parameter-group"
  
  parameter {
    apply_method  = "immediate"
    name          = "innodb_file_format"
    value         = "barracuda"
  }

  parameter {
    apply_method  = "immediate"
    name          = "innodb_large_prefix"
    value         = "1"
  }

  parameter {
    apply_method = "immediate" 
    name         = "log_output" 
    value        = "file" 
  }
  
  parameter {
    apply_method = "immediate" 
    name         = "slow_query_log" 
    value        = "1" 
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name        = "${var.project}-cluster-${var.env}"
  family      = var.db_family
  description = "Aurora-cluster-parameter-group"

  parameter {
    apply_method  = "immediate"
    name          = "innodb_file_format"
    value         = "barracuda"
  }

  parameter {
    apply_method  = "immediate"
    name          = "innodb_large_prefix"
    value         = "1"
  }

  parameter {
    apply_method = "immediate"
    name         = "slow_query_log"
    value        = "1"
  }
}