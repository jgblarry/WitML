###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Deploy Region"
}

########################
##INSTANCIA EC2 CONFIG##
########################
variable "jenkins_application" {
  description = "The tag Name for instance Jenkins"
}
variable "jenkins_instance_type" {
  description = "Instance Type from the Jenkins"
}
variable "sg_internal_ssh" {
  description = "IP whit ssh access the instance Jenkins"
}
variable "sg_jenkins" {
  description = "IP whit ssh access the instance Jenkins"
}
variable "jenkins_instance_count" {
  description = "Number of instances for deployment"
}
variable "jenkins_monitoring" {
  description = "Apply monitoring detailed to 1 min"
}

variable "jenkins_ebs_root_size" {
  description = "Customize details about the root block device of the instance."
}

variable  "private_subnet_ids"  {
  description = "Private Subnet Ids"
}
########
##TAGS##
########
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
  description = "Terraform Template"
}
variable "jenkins_userdata" {
  description = "File Script from configure instance"
}

data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
  owners = ["amazon"] #Canonical
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
variable "jenkins_hc_path" {
  description = "/"
  type    = string
}
variable "hc_port" {
  description = "80"
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
variable  "api_listener_ssl"  {
  description = "Listener SSl API"
}

variable  "deregistration_delay"  {
  description = "Delay time"
}
variable  "vpc_id"  {
  description = "ID VPC"
}