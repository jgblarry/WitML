#########################
## CONFIG REMOTE STATE ##
#########################
terraform {
  backend "s3" {
    bucket = "terraform-witadvisor-production"
    key    = "terraform.tfstate"
    dynamodb_table = "terraform_state_locking"
    region = "us-east-1"
  }
}

################################
## CONFIGURATION AWS PRIVIDER ##
################################
provider "aws" {
  version = "~> 2.8"
  region  = var.region
}

# Using these data sources allows the configuration to be generic for any region.
data "aws_region" "current" {
}

########################
## EXPORT DATA PACKER ##
########################
data "template_file" "packer" {
  template = file("./modules/ec2/packer-ami/packer-ami-template.json")
  vars = {
    public_subnet_ids  = module.vpc.public_subnet_ids[2]
    region             = var.region
  }
}