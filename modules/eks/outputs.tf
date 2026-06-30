output "eks_sgroup_id" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}
output "eks_cluster"{
  value=aws_eks_cluster.cluster.arn
}
output "endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.cluster.certificate_authority[0].data
}