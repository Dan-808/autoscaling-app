terraform {
  required_version = "1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }

  }
}

provider "aws" {
  region = var.aws_region #região mais proxima e mais barata

  profile = var.aws_profile
}