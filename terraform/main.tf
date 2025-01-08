data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile # Use the 'aws_profile' variable to determine which AWS CLI profile to use
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name

}

module "security_group" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "eks" {
  source             = "./modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_sg_id          = module.security_group.eks_sg_id
  account_id = data.aws_caller_identity.current.account_id
}



