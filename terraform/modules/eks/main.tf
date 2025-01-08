# - Ensure that the IAM role 'EC2RoleForSSM_EKS' exists and has the necessary permissions for SSM and EKS interactions.
# - Replace 'var.private_subnet_ids' with your actual list of private subnet IDs, either by defining them in a variables.tf file or passing them as input variables.

resource "aws_eks_cluster" "main" {
  name = "fastAPI-cluster" # Name of the IAM role for the EKS cluster

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids = var.private_subnet_ids

  }

  



  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}


resource "aws_eks_node_group" "main_node" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "fastAPI-node"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }



  instance_types = [ "t2.micro" ]

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Data source to reference an existing IAM role for EC2 instances with SSM access
data "aws_iam_role" "console_role" {
  name = "EC2RoleForSSM_EKS"  # Replace with the name of your existing IAM role
}


resource "aws_eks_access_entry" "additional_access" {
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = data.aws_iam_role.console_role.arn
  kubernetes_groups = ["eks-admin"]
  type              = "STANDARD"
  
}

resource "aws_eks_access_policy_association" "AdminPolicy" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_iam_role.console_role.arn

  access_scope {
    type       = "cluster"
  }
}

resource "aws_iam_role" "node_group" {
  name = "eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}


resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonEKSClusterPolicy to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" # Managed policy for EKS cluster
  role       = aws_iam_role.cluster.name
}