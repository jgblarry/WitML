###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Region de despliegue"
}
################
## DLM CONFIG ##
################
variable "interval" {
  description = "Time between executions"
}
variable "interval_unit" {
  description = "HOURS"
}
variable "times" {
  description = "Execution time"
}
variable "retain_count" {
  description = "Retain time in days"
}

###########
## TAGS  ##
###########
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
