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

### Install Required Tools

#### Ubuntu/Debian
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install kubectl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl

# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update && sudo apt-get install helm
```

#### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install AWS CLI
brew install awscli

# Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install kubectl
brew install kubectl

# Install Helm
brew install helm
```

#### Windows (PowerShell)
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

### Configure AWS Credentials

For all operating systems:
```bash
aws configure
```

Follow the prompts to enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., us-west-2)
- Default output format (json)

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

[Rest of the README content remains the same...]
