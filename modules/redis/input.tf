###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Deploy Region"
}

####################
## REDIS INSTANCE ##
####################
variable "redis_pg_family" {
  description = "redis5.0"
}
variable "redis_cluster_id" {
  description = "redis"
}
variable "redis_engine" {
  description = "redis"
}
variable "redis_node_type" {
  description = "cache.t2.small"
}
variable "redis_num_cache_nodes" {
  description = "1"
}
variable "redis_engine_version" {
  description = "5.0.4"
}
variable "redis_port" {
  description = "6379"
}
#
variable "vpc_id" {
  type    = string
}
variable "vpc_cidr" {
  type    = string
}
variable  "private_subnet_ids" {
  description = "Private subnets"  
}
##############
## ADD TAGS ##
##############
variable "env" {
  description = "Environment type"
}
variable "project" {
  description = "Project name"
}
variable "creator" {
  description = "Deploymente by"
}
variable "terraform" {
  description = "Terraform"
}

data "aws_availability_zones" "available" {
  state = "available"
}