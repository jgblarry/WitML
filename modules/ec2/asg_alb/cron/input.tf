############
## REGION ##
############
variable "region" {
  description = "Deploy Region"
}

##################
## ASG CAPACITY ##
##################
variable "cron_max_size" {
  description = "1"
}
variable "cron_min_size" {
  description = "1"
}
variable "cron_desired_capacity" {
  description = "1"
}
variable "health_check_grace_period" {
  description = "300"
}
variable "cron_instance_type" {
  description = "t3.micro"
}

variable "cron_ebs_root_size" {
  description = "20"
}
#
variable  "vpc_id"  {
  description = "VPC ID"
}     
variable  "vpc_cidr"  {
  description = "Vpc Cidr"
}                         
variable  "private_subnet_ids"  {
  description = "private_subnet_ids"
} 

variable  "sg_internal_ssh" {
  description = "SG SSH Internal"
}

##########
## TAGS ##
##########
variable  "application" {
  description = "Application name"
}
variable "env" {
  description = "production"
}
variable "project" {
  description = "witadvisor"
}
variable "creator" {
  description = "Reinaldo Leon"
}
variable "terraform" {
  description = "True"
}

