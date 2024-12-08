output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}



output "backend_ECR_url" {
  value = aws_ecr_repository.cart_service.repository_url
}
output "frontend_ECR_url" {
  value = aws_ecr_repository.react_app.repository_url
}

output "frontend_ECR_url_secondary" {
  value = aws_ecr_repository.react_app_secondary.repository_url
}

output "backend_ECR_url_secondary" {
  value = aws_ecr_repository.cart_service_secondary.repository_url
}
output "db_instance_endpoint" {
  value = "psql -h ${aws_db_instance.primary.endpoint} -U <replace_username> -p 5432"
}