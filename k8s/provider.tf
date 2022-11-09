#Terrform/AWS version 지정
terraform {
  required_version = ">=1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#provider
provider "aws" {
  region  = "ap-northeast-2" #Asia Pacific (Seoul)
  profile = "mfa"
}

