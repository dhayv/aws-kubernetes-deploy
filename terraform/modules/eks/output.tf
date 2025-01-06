output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "cluster_id" {
  value = aws_eks_cluster.main.id
}

output "node_group_id" {
  value = aws_eks_node_group.main_node.id
}

output "launch_template_id" {
  value = aws_launch_template.node_group_lt.id
}