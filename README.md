# Private EKS Cluster with SSM Access

**[Read the full deployment guide here](https://dev.to/dhayv/)**

## Overview

This repository contains Terraform configurations and deployment scripts for creating a production-grade Amazon EKS cluster within a private VPC, utilizing AWS Systems Manager (SSM) for secure access. The implementation eliminates the need for SSH keys and bastion hosts while maintaining robust security practices.

## Prerequisites

- Basic understanding of AWS networking concepts (VPCs, subnets, routing)
- AWS Account with appropriate permissions (non-root user)
- AWS CLI installed and configured
- kubectl installed
- Terraform installed
- Docker installed

## Repository Structure

```bash
Repository Structure:
├── main.py                # FastAPI application
├── Dockerfile             # Docker configuration
├── terraform/             # Terraform modules
├── fastapi-deploy.yaml    # Deployment scripts
├── fastapi-service.yaml   # Service scripts
└── requirements.txt       # Python dependencies
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/dhayv/aws-kubernetes-deploy.git
cd aws-kubernetes-deploy
```

### 2. Configure AWS Credentials

```bash
aws configure

aws sts get-caller-identity
```

### 3. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

## Technical Details

### VPC Module (`terraform/modules/vpc`)
- Provisions private VPC with public and private subnets
- Configures NAT Gateway for private subnet internet access
- Sets up routing tables and internet gateway
- Implements recommended AWS networking practices

### Security Groups Module (`terraform/modules/security-groups`)
- Configures ALB security group with port 80 access
- Sets up EKS cluster security group
- Manages cross-communication between components
- Implements least-privilege access controls

### EKS Module (`terraform/modules/eks`)
- Deploys EKS cluster in private subnets
- Configures node groups with specified instance types
- Sets up IAM roles and policies
- Implements private endpoint access

### FastAPI Application
- Sample containerized application for deployment testing
- Configured for container-based deployment
- Includes Dockerfile for image building
- Kubernetes deployment manifests included

### Components

#### FastAPI Application (`main.py`)
- Main application entry point
- RESTful API implementation
- Container-ready configuration

#### Docker Configuration (`Dockerfile`)
- Python dependencies management

#### Kubernetes Manifests
- `fastapi-deploy.yaml`: Deployment configuration
- `fastapi-service.yaml`: Service configuration
- Load balancer specifications

## Important Notes

1. **Security**: The EKS cluster is deployed in private subnets without public endpoint access
2. **Access**: Cluster access is managed through AWS Systems Manager Session Manager
3. **IAM Roles**: Required roles and policies are created via Terraform
4. **Networking**: All components are deployed within a private VPC

## Resource Cleanup

To avoid unwanted charges, clean up resources when not in use:

```bash
# Delete Kubernetes resources
kubectl delete -f fastapi-deploy.yaml
kubectl delete -f fastapi-service.yaml

# Destroy infrastructure
terraform destroy -auto-approve
```
