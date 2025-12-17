# Get current region
data "aws_region" "current" {}

# Create VPC Network
module "networking" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    availability_zones   = ["us-east-1a", "us-east-1b"]
    tags = {
      "Name" = "ct_vpc"
    }
  }
}

### Enable SSM ###
module "ssm" {
  source = "./modules/ssm"
}

### VPC Endpoints ###
resource "aws_vpc_endpoint" "vpc_endpoints" {
  for_each            = toset(var.vpc_endpoint)
  vpc_id              = module.networking.vpc_resource.vpc_id
  subnet_ids          = module.networking.vpc_resource.private_subnet_id
  service_name        = "com.amazonaws.${data.aws_region.current.id}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpce_security_group.id]
  tags = {
    "Name" = "cf_vpc_endpoint_${each.key}"
  }
}

### SG for VPC endpoint

resource "aws_security_group" "vpce_security_group" {
  vpc_id      = module.networking.vpc_resource.vpc_id
  name        = "VPC Endpoints for SSM"
  description = "Allows Inbound HTTPS Traffic to the VPC endpoints "
}

resource "aws_security_group_rule" "vpce_ingress_itself" {
  type                     = "ingress"
  description              = "Allows HTTPD traffic from itself"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce_security_group.id
  source_security_group_id = aws_security_group.vpce_security_group.id
}