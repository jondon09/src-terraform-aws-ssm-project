output "ec2_resource" {
  value = [
    "Public EC2 ID: ${module.ec2_public1.ec2_resource.instance_id[0]}",
    "Private EC2 ID: ${module.ec2_private1.ec2_resource.instance_id[0]}"
  ]
}