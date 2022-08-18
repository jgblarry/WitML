################################
## CONFIGURATION AWS PRIVIDER ##
################################
provider "aws" {
  version = "~> 2.8"
  region  = var.region
}