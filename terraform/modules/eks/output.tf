output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "cluster_id" {
  value = aws_eks_cluster.main.id
}

output "node_group_id" {
  value = aws_eks_node_group.main_node.id
}


output "cluster_name" {
  value = aws_eks_cluster.main.name
}