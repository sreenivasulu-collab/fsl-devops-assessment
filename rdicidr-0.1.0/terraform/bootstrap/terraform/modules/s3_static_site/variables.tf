variable "project" {
  description = "Project name used as prefix for resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (devel, stage, prod)"
  type        = string
}

variable "log_bucket" {
  description = "Centralized log bucket name for access logs"
  type        = string
}

variable "sse_algorithm" {
  description = "S3 encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "Optional KMS key ARN for S3 encryption"
  type        = string
  default     = ""
}
variable "aws_region" {
  description = "AWS region for the current environment"
  type        = string
}
