###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Deploy Region"
}

########################
##INSTANCIA EC2 CONFIG##
########################
variable "openvpn_instance_name" {
  description = "The tag Name for instance OpenVPN"
}
variable "openvpn_instance_type" {
  description = "Size Instance OpenVPN"
}

variable "instance_count" {
  description = "Number of instances for deployment"
  default = "1"
}
variable "openvpn_monitoring" {
  description = "Apply monitoring detailed to 1 min"
}
variable "openvpn_associate_public_ip_address" {
  description = "Attach public IP to the instance (true only if not apply Elastic IP)"
}
variable "openvpn_source_dest_check" {
  description =  "Configure in false only where the instance working with VPN service"
}
variable "openvpn_ebs_root_size" {
  description = "Customize details about the root block device of the instance."
}
variable "openvpn_userdata" {
  description = "File Script from configure instance"
}

variable  "public_subnet_ids" {
  description = "Output Ids Public Subnets"
}

variable  "vpc_id" {
  description = "Id VPC"
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