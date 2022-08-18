################################
## ZIP CREATE LAMBDA ARTIFACT ##
################################
data "archive_file" "lambda_alb_logs" {
  type        = "zip"
  source_file = "${path.module}/lambda_alb_logs.js"
  output_path = "${path.module}/lambda_alb_logs.zip"
}


###################################
## CREATE POLICY LAMBDA ALB LOGS ##
###################################
resource "aws_iam_policy" "policy" {
  name        = "alb-logs-${var.application}-${var.project}-${var.env}"
  description = var.policydescription
  policy = file("${path.module}/iam_policy.json")
}
#################################
## CREATE ROEL LAMBDA ALB LOGS ##
#################################
resource "aws_iam_role" "role" {
  name        = "alb-logs-${var.application}-${var.project}-${var.env}"
  path        = "/"
  description = var.roledescription

  assume_role_policy = file("${path.module}/iam_role.json")
}
## Asociamos la política al role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

############################
## CREATE LAMBDA ALB LOGS ##
############################
resource "aws_lambda_function" "lambda_alb_logs" {
  filename = data.archive_file.lambda_alb_logs.output_path
  function_name = "${var.lambdaname}-${var.application}-${var.env}"
  role          = aws_iam_role.role.arn
  handler       = "lambda_alb_logs.handler"
  runtime          = var.runtime
  timeout       = "60"
  source_code_hash = data.archive_file.lambda_alb_logs.output_base64sha256
}