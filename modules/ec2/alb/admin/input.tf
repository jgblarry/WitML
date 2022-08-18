############
## REGION ##
############
variable "region" {
  description = "Deployment Region"
}

#######################
## ALB CONFIGURATION ##
#######################
variable "internal" {
  description = "false"
}
variable "enable_deletion_protection" {
  description = "false"
}
variable "deregistration_delay" {
  description = "30"
}
variable "idle_timeout" {
  description = "30"
}
variable "access_logs" {
  description = "true"
}
##################
## TARGET GROUP ##
##################
variable "target_group_protocol" {
  description = "HTTP"
}
variable "target_group_port" {
  description = "80"
}
variable "target_group_target_type" {
  description = "instance"
}
#########################
## HEALTH CHECK CONFIG ##
#########################
variable "hc_protocol" {
  description = "HTTP"
  type    = string
}
variable "hc_path" {
  description = "/health"
  type    = string
}
variable "hc_port" {
  description = "80"
  type    = string
}
variable "healthy_threshold" {
  description = "2"
}
variable "unhealthy_threshold" {
  description = "4"
}
variable "hc_timeout" {
  description = "4"
  type    = string
}
variable "hc_interval" {
  description = "15"
  type    = string
}
variable "hc_matcher" {
  description = "200,301,302"
  type    = string
}

#######################
## STICKINESS CONFIG ##
#######################
variable "stickiness" {
  description = "false"
}
variable "stickiness_type" {
  description = "lb_cookie"
}
variable "stickiness_cookie_duration" {
  description = "60"
}
variable "stickiness_enabled" {
  description = "false"
}
##
variable "vpc_id" {
  description = "VPC ID"
} 
variable  "public_subnet_ids" {
  description = "public_subnet_ids"
}                           
variable  "admin_lambda_arn"  {
  description = "admin_lambda_arn"
}
variable  "admin_lambda_name" {
  description = "admin_lambda_name"
}
variable  "certificate_arn" {
  description = "certificate_arn"
}
    

##########
## TAGS ##
##########

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
variable  "application" {
  description = "Application Name admin"
}