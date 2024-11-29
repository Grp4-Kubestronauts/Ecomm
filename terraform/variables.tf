variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2" # Change this to your region
}

variable "secondary_aws_region" {
  description = "Secondary AWS region for DR"
  type        = string
  default     = "us-west-2" # Change as needed
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

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "react-app-eks"
}

variable "vpc_cidr_secondary" {
  description = "CIDR block for the secondary region's VPC"
  type        = string
  default     = "10.1.0.0/16" # Change this to an appropriate CIDR block
}
