# Terraform EKS Infrastructure Guide

This repository contains Terraform modules for creating a complete Amazon EKS (Elastic Kubernetes Service) infrastructure with VPC, EKS cluster, node groups, and ALB Ingress Controller.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Repository Structure](#repository-structure)
3. [Getting Started](#getting-started)
4. [Module Management](#module-management)
5. [Step-by-Step Guide](#step-by-step-guide)
6. [Customization](#customization)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

1. Install required tools:
```powershell
# Install AWS CLI
winget install -e --id Amazon.AWSCLI

# Install Terraform
winget install -e --id Hashicorp.Terraform

# Install kubectl
winget install -e --id Kubernetes.kubectl

# Install helm
winget install -e --id Helm.Helm
```

2. Configure AWS credentials:
```powershell
aws configure
```

## Repository Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf             # Output definitions
└── modules/
    ├── vpc/               # VPC module
    ├── eks/               # EKS cluster module
    ├── node_groups/       # EKS node groups module
    └── alb_ingress/       # ALB ingress controller module
```

## Getting Started

1. Clone the repository:
```powershell
git clone https://github.com/Soumya14041987/Terraform-End-to-End.git
cd Terraform-End-to-End
```

2. Initialize Terraform:
```powershell
terraform init
```

3. Create a `terraform.tfvars` file with your configurations:
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

4. Review the plan:
```powershell
terraform plan
```

5. Apply the configuration:
```powershell
terraform apply
```

## Module Management

### Understanding Module Structure
Each module contains three main files:
- `main.tf`: Main resource definitions
- `variables.tf`: Input variables
- `outputs.tf`: Output values

### Using Modules

1. **Basic Module Usage**:
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cluster_name = var.cluster_name
  vpc_cidr    = var.vpc_cidr
}
```

2. **Module Dependencies**:
Modules automatically handle dependencies through output variables:
```hcl
module "eks" {
  source = "./modules/eks"
  
  cluster_name      = var.cluster_name
  vpc_id           = module.vpc.vpc_id          # Using VPC module output
  subnet_ids       = module.vpc.private_subnets # Using VPC module output
}
```

3. **Local vs Remote Modules**:
- Local modules: `source = "./modules/vpc"`
- Git modules: `source = "github.com/username/repo//modules/vpc"`
- Registry modules: `source = "terraform-aws-modules/vpc/aws"`

## Step-by-Step Guide

### 1. VPC Setup
```hcl
# Example VPC customization in terraform.tfvars
vpc_cidr = "172.16.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]
```

### 2. EKS Cluster Creation
```hcl
# Example EKS customization
cluster_name = "production-cluster"
kubernetes_version = "1.27"
```

### 3. Node Groups Configuration
```hcl
# Example node group customization
desired_size = 3
max_size = 6
instance_types = ["t3.large"]
```

### 4. ALB Ingress Setup
```hcl
# Example ALB configuration
alb_controller_version = "1.5.3"
```

## Managing Infrastructure

### 1. Making Changes
1. Edit the relevant `.tf` files or `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Apply changes with `terraform apply`

### 2. Adding New Resources
1. Add resource definitions to the relevant module
2. Update variables and outputs as needed
3. Run Terraform init if adding new providers

### 3. State Management
```powershell
# List resources in state
terraform state list

# Show resource details
terraform state show module.vpc.aws_vpc.main

# Remove resource from state (if needed)
terraform state rm module.vpc.aws_vpc.main
```

### 4. Module Updates
1. Make changes to module code
2. Run `terraform init` to reinitialize
3. Use `terraform plan` to verify changes

## Customization

### 1. Variables
Customize through `terraform.tfvars`:
```hcl
# Basic customization
aws_region = "us-east-1"
cluster_name = "staging-cluster"

# Advanced VPC settings
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Node group configuration
desired_size = 3
max_size = 5
min_size = 1
instance_types = ["t3.large"]
```

### 2. Adding Custom Tags
Add to any module's variables:
```hcl
tags = {
  Environment = "Production"
  Team = "DevOps"
  Project = "EKS-Platform"
}
```

## Troubleshooting

### Common Issues and Solutions

1. **Initialization Failures**
```powershell
# Clear terraform cache
Remove-Item -Recurse -Force .terraform/
terraform init
```

2. **State Lock Issues**
```powershell
# Force unlock if needed (use with caution)
terraform force-unlock [LOCK_ID]
```

3. **Plan/Apply Failures**
- Check AWS credentials
- Verify IAM permissions
- Review error messages in detail

### Getting Help

1. Check module documentation:
- VPC: `modules/vpc/README.md`
- EKS: `modules/eks/README.md`
- ALB Ingress: `modules/alb_ingress/README.md`

2. View Terraform logs:
```powershell
$env:TF_LOG="DEBUG"
terraform apply
```

### Best Practices

1. Always use version control
2. Document changes in commit messages
3. Use workspaces for different environments:
```powershell
# Create and use workspaces
terraform workspace new staging
terraform workspace select staging
```

4. Regular state backups:
```powershell
Copy-Item terraform.tfstate terraform.tfstate.backup
```

## Support and Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
