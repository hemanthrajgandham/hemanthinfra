output "ecr_repository_urls" {
  value = { for repo in aws_ecr_repository.main : repo.name => repo.repository_url }
  description = "Map of ECR repository names to their URLs"
}
output "ecr_registry_ids" {
  value = { for repo in aws_ecr_repository.main : repo.name => repo.registry_id }
  description = "Map of ECR repository names to their Registry IDs"
}