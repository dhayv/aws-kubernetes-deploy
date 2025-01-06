# ALB Security group
resource "aws_security_group" "alb" {
  name = "${var.project_name}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-eks-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EKS Secuirty group
resource "aws_security_group" "eks" {
  name = "${var.project_name}-eks-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-eks-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress Rule: Allow ALB to communicate with EKS

resource "aws_security_group_rule" "allow_alb" {
  type = "ingress"
  security_group_id = aws_security_group.eks.id
  source_security_group_id = aws_security_group.alb.id
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
  
}

# Egress Rule: Allow EKS to outbound traffic
resource "aws_security_group_rule" "allow_eks_egress" {
  type = "egress"
  security_group_id = aws_security_group.eks.id
  from_port         = 0
  protocol       = "-1"
  to_port           = 0
  cidr_blocks = [ "0.0.0.0/0" ]
}

# ALB Ingress Rules
resource "aws_security_group_rule" "allow_alb_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  cidr_blocks         = ["0.0.0.0/0"]
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow_alb_egress" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  cidr_blocks          = ["0.0.0.0/0"]
  to_port = 0
  from_port = 0
  protocol       = "-1" # semantically equivalent to all ports
}