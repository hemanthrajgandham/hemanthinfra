output "repo_urls" {
  value = module.ecr.ecr_repository_urls
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster
}

output "endpoint" {
  value =  module.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.kubeconfig-certificate-authority-data
}