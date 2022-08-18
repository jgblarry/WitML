###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Región de despliegue"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "vpc_cidr" {
  type    = string
}

variable  "prefixess_cidr" {
  description = "Prefixess CIDR Subnet"
}

variable "publicIp" {
  default = "true"
}

variable "enable_dns_hostnames" {
  description = "Support DNS Host Name"
  default     = "true"
}
variable "enable_dns_support" {
  description = "Support DNS"
  default     = "true"
}

variable "azs" {
  type  = list
}

#variable  "sg_ssh_access" {
#  description =   "Admin access SG VPC" 
#}
##############
## ADD TAGS ##
##############
variable "project" {
  description = "Nombre del projecto"
}
variable "env" {
  description = "Entorno de trabajo"
}
variable "creator" {
  description = "Creador del stack"
}
variable "terraform" {
  description = "Desplegado con terraform"
}