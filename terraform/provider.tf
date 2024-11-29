provider "aws" {
  region = var.aws_region
  alias  = "primary"
}

provider "aws" {
  region = var.secondary_aws_region
  alias  = "secondary"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}