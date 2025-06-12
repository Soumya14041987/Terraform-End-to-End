output "node_group_arn" {
  description = "ARN of the node group"
  value       = aws_eks_node_group.node_group.arn
}

output "node_group_id" {
  description = "ID of the node group"
  value       = aws_eks_node_group.node_group.id
}
