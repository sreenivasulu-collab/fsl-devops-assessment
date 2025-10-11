terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "environment" {
  description = "Environment name (devel, stage, prod)"
  type        = string
}

# --- S3 bucket for remote state ---
resource "aws_s3_bucket" "tf_state" {
  bucket = "fsl-devops-tfstate-${var.environment}-${var.aws_region}"

  tags = {
    Name        = "tfstate-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --- DynamoDB table for locking ---
resource "aws_dynamodb_table" "tf_lock" {
  name         = "fsl-devops-lock-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tf-lock-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
