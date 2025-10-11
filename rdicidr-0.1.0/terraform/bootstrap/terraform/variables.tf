variable "aws_profile" {
  description = "AWS CLI profile for the environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "tf_state_bucket" {
  description = "S3 bucket name for remote Terraform state"
  type        = string
}

variable "tf_lock_table" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}
