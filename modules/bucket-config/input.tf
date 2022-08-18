#####################
## VARIABLE GLOBAL ##
#####################
variable "region" {
    description =  "Region de despliegue"
}
##########
## TAGS ##
##########
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