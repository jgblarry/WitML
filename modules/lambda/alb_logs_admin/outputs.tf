output "lambda_arn" {
  value = "${aws_lambda_function.lambda_alb_logs.arn}"
}

output "lambda_name" {
  value = "${aws_lambda_function.lambda_alb_logs.id}"
}