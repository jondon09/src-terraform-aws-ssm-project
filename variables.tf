variable "aws_region" {
  description = "The aws region to deploy in."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "profile for Deploying resource on AWS."
  type        = string
  default     = "iamadmin-general"
}