# Local variable to store the number of public and private subnets
locals {
  num_of_public_subnets  = length(var.vpc_config.availability_zones)
  num_of_private_subnets = length(var.vpc_config.availability_zones)
}

# data source for current aws region
data "aws_region" "current" {}

## VPC ##
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  enable_dns_support   = var.vpc_config.enable_dns_support
  tags                 = var.vpc_config.tags
}

### Internet Gateway ###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "cf_igw"
  }
}

### Public Subnet ###

resource "aws_subnet" "public" {
  count             = local.num_of_public_subnets
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.vpc_config.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 2, count.index + 1) # automatically creates VPC CIDR based on CIDR Block
  tags = {
    "Name" = "cf_public_subnet_${count.index + 1}"
  }

}

# Route table for Public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw
  }
}