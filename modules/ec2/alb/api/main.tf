###################
## CREATE   ALB ##
###################
resource "aws_security_group" "alb" {
  name        = "sg_${var.application}-${var.project}-${var.env}"
  description = "Allow ssh inbound traffic VPC only"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg_${var.application}-${var.project}-${var.env}"
    Create_by   = "${var.creator}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Terraform   = "${var.terraform}"
  }
}

###############################
## CREATE S3 BUCKET FOR LOGS ##
###############################
resource "aws_s3_bucket" "bucket" {
  bucket = "alb-${var.application}-${var.project}-${var.env}"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-1610392315612",
    "Statement": [
        {
            "Sid": "AWSConsoleStmt-1610392315612",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::127311923021:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alb-api-witadvisor-production/*"
        }
    ]
}
EOF

  tags = {
    Name        = "alb-${var.application}-${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id
  lambda_function {
    lambda_function_arn = var.api_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "*"
    #filter_suffix       = "*"
  }
}
resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
  depends_on    = [aws_s3_bucket.bucket]
}
#########################
## CREATE TARGET GROUP ##
#########################
resource "aws_lb_target_group" "tg_alb" {
  name        = "TG-${var.application}-${var.project}-${var.env}"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    protocol            = var.hc_protocol
    path                = var.hc_path
    port                = var.hc_port
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.hc_timeout
    interval            = var.hc_interval
    matcher             = var.hc_matcher
  }
  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    enabled         = var.stickiness_enabled
  }
  tags = {
    Name        = "TG-${var.application}-${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
################
## CREATE ALB ##
################
resource "aws_lb" "alb" {
  name               = "ALB-${var.application}-${var.project}-${var.env}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  ## Deploy ALB AZa + AZb ##
  subnets             = ["${var.public_subnet_ids[0]}", "${var.public_subnet_ids[1]}", "${var.public_subnet_ids[2]}"]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

  ## CONFIGURE ALB LOGS EXPORT S3 BUCKET ##
  access_logs {
    enabled = var.access_logs
    bucket  = aws_s3_bucket.bucket.id
  }

  tags = {
    Name        = "ALB-${var.application}-${var.project}-${var.env}"
    Create_by   = var.creator
    Project     = var.project
    Environment = var.env
    Terraform   = var.terraform
  }
}
resource "aws_lb_listener" "alb_config" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "alb_config_ssl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }
}