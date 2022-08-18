############
## OUTPUT ##
############
output "application_name" {
  value = aws_codedeploy_app.application.*.name
}

output "deployment_config_name" {
  value = var.deployment_config_name
}
output "deployment_type" {
  value = var.deployment_type
}