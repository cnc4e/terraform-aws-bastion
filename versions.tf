terraform {
  required_version = ">= 1.8.5"

  required_providers {
    aws = {
      version = ">= 5.58.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket       = "terraform-aws-bastion-tfstate"
    key          = "bastion.tfstate"
    region       = "ap-northeast-3"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}