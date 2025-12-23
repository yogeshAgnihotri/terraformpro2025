##===============provide information of target cloud============
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
##============== provide aws cloud authentication and region info==================
# Configure the AWS Provider
provider "aws" {
  region = "${var.AWS_REGION}"
  access_key = "${var.akey}"
  secret_key = "${var.skey}"
}

