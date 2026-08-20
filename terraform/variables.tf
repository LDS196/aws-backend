variable "region" {
  description = "AWS регион"
  type        = string
  default     = "eu-central-1"
}
 
variable "cluster_name" {
  description = "Имя EKS кластера"
  type        = string
  default     = "devops-cluster"
}
 
variable "cluster_version" {
  description = "Версия Kubernetes"
  type        = string
  default     = "1.36"
}
 
variable "node_instance_type" {
  description = "Тип EC2 инстанса для нод"
  type        = string
  default     = "t3.medium"
}
 
variable "node_desired_capacity" {
  type    = number
  default = 2
}
 
variable "node_min_size" {
  type    = number
  default = 1
}
 
variable "node_max_size" {
  type    = number
  default = 3
}
 
variable "node_disk_size" {
  description = "Размер диска ноды в GB"
  type        = number
  default     = 20
}