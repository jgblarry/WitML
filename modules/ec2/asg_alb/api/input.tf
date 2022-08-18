############
## REGION ##
############
variable "region" {
  description = "Deploy Region"
}

##################
## ASG CAPACITY ##
##################
variable "max_size" {
  description = "2"
}
variable "min_size" {
  description = "2"
}
variable "desired_capacity" {
  description = "2"
}
variable "health_check_grace_period" {
  description = "300"
}
variable "api_instance_type" {
  description = "t3.medium"
}


####################
## Scaling Policy ##
####################

variable "cooldown" {
  description = "120"
}

variable "metric_name" { 
  description = "CPUUtilization"  #MemoryUtilization
}

variable "namespace" {
  description = "AWS/EC2"     #System/Linux
}
variable "statistic" {
  description = "Maximum"     #Average
}

variable "threshold_up" {
  description = "70"
}
variable "threshold_down" {
  description = "30"
}

variable "ebs_root_size" {
  description = "60"
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
variable  "sg_alb"  {
  description = "Security Group ALB"
}  
variable "aws_lb_target_group"  {
  description = "Target Group ID"
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

