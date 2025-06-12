provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  cluster_name        = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "node_groups" {
  source = "./modules/node_groups"

  cluster_name      = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_size      = var.desired_size
  max_size          = var.max_size
  min_size          = var.min_size
  instance_types    = var.instance_types
}
