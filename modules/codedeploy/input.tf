############
## REGION ##
############
variable "region" {
  description = "Deploy Region"
}
################
## APP CONFIG ##
################
variable "compute_platform" {
  description = "Server"
}
variable "deployment_config_name" {
  description = "CodeDeploydescription.OneAtATime"
}
variable "deployment_type" {
  description = "IN_PLACE"
}
variable "deployment_option" {
  description = "WITH_TRAFFIC_CONTROL"
}
variable "deployment_option_cron"{
  description = "WITHOUT_TRAFFIC_CONTROL"
}
variable  "codedeploy_applications" {
  description = "Applications Name"
}
variable  "codedeploy_cron"{
  description = "Applications Name"
}
variable  "codedeploy_env"  {
  description = "Env Codedeploy"
}
 variable "autoscaling_groups" {
   description = "ASG Name"
 }
 variable "albs"  {
   description  = "ALB Ids"
 }
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
