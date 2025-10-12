terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Remove profile — rely on AWS CLI or environment variables

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Owner       = "DevOpsTeam"
      Compliance  = "FullstackLabs"
      Environment = var.environment
      Project     = var.project
    }
  }
}
