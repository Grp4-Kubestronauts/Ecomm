output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.react_app.repository_url
}

output "ecr_repository_url_secondary" {
  value = aws_ecr_repository.react_app_secondary.repository_url
}

output "cluster_name_secondary" {
  value = aws_eks_cluster.secondary.name
}
