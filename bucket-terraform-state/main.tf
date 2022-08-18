resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-${var.project}-${var.env}"
  acl    = "private"
  tags = {
    Name        = "terraform-${var.project}-${var.env}"
    Environment = var.env
    Creator     = var.creator
    Terraform   = var.terraform
  }
}

##CREATE DYNAMODB TABLE PARA BLOQUEAR EL ESTADO
resource "aws_dynamodb_table" "terraform_state_locking" {
  name = "terraform_state_locking"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Name        = "terraform-${var.project}-${var.env}"
    Environment = var.env
    Creator     = var.creator
    Terraform   = var.terraform
  }
}