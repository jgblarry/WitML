resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project}-config"
  acl    = "private"
  tags = {
    Name        = "${var.project}-config"
    Environment = var.env
    Creator     = var.creator
    Terraform   = var.terraform
  }
  provisioner "local-exec" {
    command = "sleep 5"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "upload_build" {
  provisioner "local-exec" {
     command = "sleep 5"
     interpreter = ["/bin/bash", "-c"]
   }
 }

# resource "aws_s3_bucket_object" "api-config" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "api-wit.conf"
#   source = "${path.module}/files-prod/wit.conf"
# }

# resource "aws_s3_bucket_object" "admin-config" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "admin-wit.conf"
#   source = "${path.module}/files-prod/wit.conf"
# }

resource "aws_s3_bucket" "bucket-codedeploy" {
  bucket = "codedeploy-${var.project}-${var.env}"
  acl    = "private"
  tags = {
    Name        = "codedeploy-${var.project}-${var.env}"
    Environment = var.env
    Creator     = var.creator
    Terraform   = var.terraform
  }
  provisioner "local-exec" {
    command = "sleep 5"
    interpreter = ["/bin/bash", "-c"]
  }
}
