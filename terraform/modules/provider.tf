provider "aws" {
  region = var.aws_region
}
provider "aws" {
  region = var.aws_region_secondary
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