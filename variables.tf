variable "aws_region" {
  description = "The aws region to deploy in."
  type        = string
}

variable "aws_profile" {
  description = "profile for Deploying resource on AWS."
  type        = string
}

variable "backend_bucket" {
  description = "Name of the backend bucket for remote backend."
  type        = string
}

variable "dynamo_table" {
  description = "name of dynamo table for remote locking."
  type        = string
}

variable "vpc_endpoint" {
  type        = list(string)
  description = "A list of VPC endpoint to create"
  default     = ["ssm", "ssmmessages"]
}

