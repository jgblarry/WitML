###################
## DEPLOY REGION ##
###################
variable "region" {
  description = "Region de despliegue"
}
############################
## DEPLOY AURORA INSTANCE ##
############################

variable "aurora_engine" {
  description = "BBDD engine"
}
variable "version_engine" {
  description = "Version for BBDD engine"
}
variable "replica_count" {
  description = "Write and Read replica number to deploy"
}
variable "instance_type" {
  description = "Type instance to deploy"
}

variable "db_family" {
  description     = "Family Database"
}
variable "iam_database_authentication_enabled" {
  description = "Use iam autentication"
}
variable "username" {
  description = "Usuario administrador para el RDS"
}
variable "password" {
  description = "Se debe generar un Passwd por cada despliegue"
}
variable "database_name" {
  description = "Database name for default schema"
}

###if you change the accessibility of the data to public,         ###
###you must modify the subnet before they can have public access  ###
variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
}
variable "backup_retention_period" {
  description = "The retention period from RDS snapshot"
}
variable "monitoring_interval" {
  description = "Monitoring interval"
}
#
variable  "vpc_id"  {
  description = "VPC ID"
}
variable  "vpc_cidr"  {
  description = "VPC CIDR"
}
variable  "database_subnet_ids" {
  description = "Database Subnets IDs"
}
variable  "replica_scale_enabled" {
  description = "Configure ASG Read Replica"
}
variable  "replica_scale_cpu" {
  description = "Scaling Condition"
}
variable  "replica_scale_min" {
  description = "Number min replica"
}
variable  "replica_scale_max" {
  description = "Number max replica"
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

