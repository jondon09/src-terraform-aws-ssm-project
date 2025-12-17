terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}
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

### Public Subnets and associated Route tables ###

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

# Associates the route table with a Public Subnet
resource "aws_route_table_association" "public" {
  count          = local.num_of_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

### Private Subnets and associated Route tables ###

resource "aws_subnet" "private" {
  count             = local.num_of_private_subnets
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.vpc_config.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 1) # automatically creates VPC CIDR based on CIDR Block
  tags = {
    "Name" = "cf_private_subnet_${count.index + 1}"
  }

}

resource "aws_route_table" "private" {
  count  = local.num_of_private_subnets
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count          = local.num_of_private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# Elastic IP for NAT Gateway
resource "aws_eip" "ngw" {
  count = local.num_of_public_subnets
  tags = {
    "Name" = "cf_nat_gateway_${count.index + 1 }"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = local.num_of_public_subnets
  allocation_id = element(aws_eip.ngw[id].id, count.index)
  subnet_id = element(aws_subnet.public[*].id, count.index)
  depends_on = [aws_internet_gateway.igw]

  tags = {
    "Name" = "cf_nat_gateway_${count.index + 1}"
  }

}