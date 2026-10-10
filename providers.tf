terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket = "infra-bucket-04"
    key    = "infra/terraform.tfstate"
    region = var.aws_region
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}
