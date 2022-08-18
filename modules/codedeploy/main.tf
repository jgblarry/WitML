
################################
## CREATE ROLE IAM CODEDEPLOY ##
################################
resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-${var.project}-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}
###############################
##CREATE APPLICATION SERVICE ##
###############################
resource "aws_codedeploy_app" "application" {
  compute_platform = var.compute_platform
  name             = "${var.project}-${var.codedeploy_env[0]}"
}

resource "aws_codedeploy_deployment_group" "application" {
  count                   = length(var.codedeploy_applications)
  app_name                = aws_codedeploy_app.application.name
  deployment_group_name   = element(var.codedeploy_applications, count.index)
  service_role_arn        = aws_iam_role.codedeploy.arn
  deployment_config_name  = var.deployment_config_name
  deployment_style  {
    deployment_option     = var.deployment_option
    deployment_type       = var.deployment_type
  }
  autoscaling_groups      = [var.autoscaling_groups[count.index]]
  load_balancer_info  {
    target_group_info {
        name  = var.albs[count.index]
    }
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

resource "aws_codedeploy_deployment_group" "cron" {
  app_name                = aws_codedeploy_app.application.name
  deployment_group_name   = var.codedeploy_cron
  service_role_arn        = aws_iam_role.codedeploy.arn
  deployment_config_name  = var.deployment_config_name
  deployment_style  {
    deployment_option     = var.deployment_option_cron
    deployment_type       = var.deployment_type
  }
  autoscaling_groups      = [var.autoscaling_groups[2]]
  
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}