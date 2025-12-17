output "ec2_resource" {
  value = {
    instance_id = aws_instance.instance[*].id
    public_dns  = aws_instance.instance[*].public_dns
    private_dns = aws_instance.instance[*].private_dns
  }
  description = "EC2 Instance properties"
}