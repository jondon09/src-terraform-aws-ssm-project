# AWS VPC with Systems Manager Secure Access - Terraform Project

A production-ready Terraform project with remote backend and state locking, that builds a complete AWS VPC infrastructure with secure EC2 instance access via AWS Systems Manager (SSM), eliminating the need for bastion hosts and SSH key management.

## Project Overview

This project demonstrates infrastructure-as-code best practices by deploying a secure, scalable VPC architecture with the following components:

- **VPC Network Module**: Fully configurable virtual private cloud with automatic subnet, route table, and gateway provisioning
- **High Availability**: Multi-AZ deployment with both public and private subnets
- **Secure Access**: AWS Systems Manager Session Manager for keyless EC2 access via AWS private network
- **Least Privilege IAM**: Dedicated IAM role with minimal required permissions for SSM operations
- **Network Security**: SSM VPC endpoint for private, secure traffic routing without internet exposure
- **Compute**: Two Amazon Linux 2 EC2 instances (one public, one private) with pre-installed SSM agent
- **Test**: BDD testing using terraform-compliance for security and compliance.

## Architecture
<img title="Terraform Architecture Diagram" src="/Terraform-on-aws.svg">


## Key Features

**Infrastructure as Code**: Modular Terraform configuration for easy replication and maintenance  
**Secure Access**: No SSH keys or bastion hosts required  
**Scalable Design**: Variables for CIDR blocks and AZ configuration  
**Cost Optimized**: SSM VPC endpoint routes traffic through AWS private network  
**High Availability**: Multi-AZ deployment for fault tolerance  
**Best Practices**: IAM least privilege, variable inputs, and modular structure

## Prerequisites

- Terraform >= 1.13.2
- AWS CLI configured with appropriate credentials
- AWS account with appropriate permissions (EC2, VPC, IAM, Systems Manager, VPC Endpoints)
- Terraform variables configured (see Configuration section)

## Project Structure

```
.
├── main.tf                 
├── variables.tf            
├── outputs.tf              
├── terraform.tfvars        
├── modules/
│   └── vpc/
│       ├── main.tf        
│       ├── variables.tf    
│       └── outputs.tf      
├── modules/
│   └── ec2/
│       ├── main.tf         
│       ├── variables.tf    
│       └── outputs.tf      
├── modules/
│   └── ssm/
│       ├── main.tf         
│       ├── variables.tf    
│       └── outputs.tf      
└── README.md
```
## Deployment Instructions

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the Plan

```bash
terraform plan -out=tfplan
```

### 3. Apply Configuration

```bash
terraform apply tfplan
```

Terraform will provision all AWS resources. This typically takes 5-10 minutes.

### 4. Verify Deployment

```bash
terraform output
```

Captures EC2 instance IDs and VPC information for next steps.

## Accessing EC2 Instances via AWS Systems Manager

### Prerequisites
- AWS CLI installed and configured
- AWS Systems Manager Session Manager plugin installed
- Appropriate IAM permissions to use Session Manager

### Access Public Subnet Instance

```bash
aws ssm start-session --target <instance-id-public> --region us-east-1
```

### Access Private Subnet Instance

```bash
aws ssm start-session --target <instance-id-private> --region us-east-1
```

Replace `<instance-id-public>` and `<instance-id-private>` with actual instance IDs from Terraform output.

### Verify SSM Agent Status

Once connected via SSM:

```bash
sudo systemctl status amazon-ssm-agent
```

## Destroying Resources

To clean up and avoid ongoing charges:

```bash
terraform destroy
```

## Next Steps / Enhancements

- Add CloudWatch monitoring and alarms
- Implement Auto Scaling Group for production workloads
- Configure VPC Flow Logs for network traffic analysis
- Add RDS database in private subnet
- Implement Infrastructure CI/CD pipeline
- Add Application Load Balancer for multi-instance deployments


## License

This project is provided for educational and portfolio purposes.

## Author: John Nkanu | DevOps Engineer/ Cloud Engineer 

---
**Last Updated**: December 2025
