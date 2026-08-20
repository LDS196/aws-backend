output "cluster_name" {
  value = aws_eks_cluster.main.name
}
 
output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}
 
output "ecr_repository_url" {
  description = "URL репозитория для docker push"
  value       = aws_ecr_repository.backend.repository_url
}
 
output "configure_kubectl" {
  description = "Команда для получения kubeconfig"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.region}"
}