terraform {
  required_version = ">= 1.8.5"

  required_providers {
    aws = {
      version = ">= 5.58.0"
      source  =      "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}