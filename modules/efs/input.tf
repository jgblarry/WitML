###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Region"
}
###########
## TAGS  ##
###########
variable "project" {
  description = "proyectos"
}
variable "env" {
  description = "Develop"
}
variable "creator" {
  description = "WitAdvisor"
}
variable "terraform" {
  description = "True"
}

variable  "vpc_id" {
  description = "vpc_id"
}
variable  "vpc_cidr"  {
  description = "CIDR"
}
variable "private_subnet_ids"  {
  description = "Ids Subnets"
}