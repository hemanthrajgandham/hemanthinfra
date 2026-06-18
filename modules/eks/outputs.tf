output "eks_sgroup_id" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}