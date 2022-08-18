variable "region" {
  description = "Deplyment Region"
}
variable "policydescription" {
  default = "IAM Policy from Lambda ALB Logs to CloudWatch"
}
variable "roledescription" {
  default = "IAM Role from Lambda ALB Logs to CloudWatch"
}
variable "lambdaname" {
  type    = string
  default = "Alb_Logs"
}
variable "runtime" {
  description = "nodejs10.x"
}
variable  "application" {
  description = "Define the application"
}
variable "env" {
  type = string
}
variable "project" {
  type = string
}
