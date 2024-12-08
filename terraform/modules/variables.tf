variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"  # Change this to your region
}

variable "aws_region_secondary"{
  description = "Secondary AWS region"
  type = string
  default = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_secondary" {
  description = "CIDR block for the secondary region's VPC"
  type        = string
  default     = "10.1.0.0/16" # Change this to an appropriate CIDR block
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "react-app-eks"
}

variable "allowed_ip_range" {
  description = "CIDR block for IPs allowed to connect to the bastion host"
  type        = string
  default     = "0.0.0.0/0"  
}
