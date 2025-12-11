terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = var.backend_bucket
    key            = "src-terraform-aws-ssm-project/terraform.tfstate"
    region         = var.aws_region
    profile        = var.aws_profile
    dynamodb_table = var.dynamo_table
    encrypt        = "true"
  }
}



provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}