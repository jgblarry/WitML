#################################
##CREATE REDIS SECURITY GROUPS ##
#################################
resource "aws_security_group" "redis" {
  name        = "sg_redis_${var.project}-${var.env}"
  description = "Allow inbound traffic VPC only by 3306 port"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 6379
    to_port     = 6379
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
    Name        = "sg_redis_${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
###############################
## ELASTICHACHE SUBNET GROUP ##
###############################
resource "aws_elasticache_subnet_group" "redis" {
  name       = "sg-${var.project}-${var.env}"
  subnet_ids = ["${var.private_subnet_ids[0]}", "${var.private_subnet_ids[1]}"]
}

###################################
## ELASTICHACHE PARAMETERS GROUP ##
###################################
resource "aws_elasticache_parameter_group" "pg-redis" {
  name   = "pg-${var.project}-${var.env}"
  family = var.redis_pg_family

#  parameter {
#    value = "yes"
#    name  = "activerehashing"
#  }
}
###############################
## ELASTICACHE CLUSTER REDIS ##
###############################
resource "aws_elasticache_cluster" "ps-redis" {
  cluster_id           = var.redis_cluster_id
  engine               = var.redis_engine
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.pg-redis.name
  engine_version       = var.redis_engine_version
  port                 = var.redis_port
  security_group_ids   = [aws_security_group.redis.id]
  availability_zone    = data.aws_availability_zones.available.names[0]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}