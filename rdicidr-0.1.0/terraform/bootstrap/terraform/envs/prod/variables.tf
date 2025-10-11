variable "project" {
  description = "Project name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (devel, stage, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for this environment"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "log_bucket" {
  description = "S3 bucket for access logs"
  type        = string
}

variable "sse_algorithm" {
  description = "S3 encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "Optional KMS key ARN for encryption"
  type        = string
  default     = ""
}

variable "price_class" {
  description = "CloudFront price class (PriceClass_100, 200, or All)"
  type        = string
  default     = "PriceClass_100"
}
