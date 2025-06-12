# Terraform EKS Cluster Modules

This repository contains Terraform modules for creating an Amazon EKS (Elastic Kubernetes Service) cluster with associated infrastructure.

## Module Structure

- `modules/vpc`: VPC configuration with public and private subnets
- `modules/eks`: EKS cluster configuration
- `modules/node_groups`: EKS node groups configuration

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0.0 or later)
- kubectl installed (for cluster management)

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

## Customization

You can customize the deployment by modifying the variables in `variables.tf` or by creating a `terraform.tfvars` file with your desired values:

```hcl
aws_region         = "us-west-2"
cluster_name       = "my-eks-cluster"
vpc_cidr          = "10.0.0.0/16"
kubernetes_version = "1.27"
desired_size      = 2
max_size          = 4
min_size          = 1
instance_types    = ["t3.medium"]
```

## Modules

### VPC Module
- Creates a VPC with public and private subnets
- Sets up NAT Gateways for private subnet internet access
- Configures necessary routing tables

### EKS Module
- Creates the EKS cluster control plane
- Sets up IAM roles and policies
- Configures cluster endpoint access

### Node Groups Module
- Creates managed node groups for the EKS cluster
- Configures auto-scaling settings
- Sets up necessary IAM roles and policies

## Clean Up

To destroy the created resources:
```bash
terraform destroy
```

## Security Considerations

- The cluster has both public and private endpoint access enabled
- Worker nodes are placed in private subnets
- IAM roles follow the principle of least privilege

## Contributing

Feel free to submit issues and enhancement requests!
