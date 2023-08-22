output "eks_cluster_name" {
    value = aws_eks_cluster.public_aws_eks.name
}
output "eks_node_group_name" {
    value = aws_eks_node_group.node.node_group_name
}