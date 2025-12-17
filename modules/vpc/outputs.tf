output "vpc_resource" {
  value = {
    vpc_id              = aws_vpc.vpc.id
    public_subnet_ids   = aws_subnet.public[*].id
    private_subnet_id   = aws_subnet.private[*].id
    internet_gateway_id = aws_internet_gateway.igw.id
    nat_gateway_id      = aws_nat_gateway.ngw[*].id
  }
}