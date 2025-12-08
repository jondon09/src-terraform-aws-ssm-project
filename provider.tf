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
    bucket         = "terraform-backend-31112025"
    key            = "src-terraform-aws-project/terraform.tfstate"
    region         = "us-east-1"
    profile        = "iamadmin-general"
    dynamodb_table = "terraform_state_lock"
    encrypt        = "true"
  }
}



provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}