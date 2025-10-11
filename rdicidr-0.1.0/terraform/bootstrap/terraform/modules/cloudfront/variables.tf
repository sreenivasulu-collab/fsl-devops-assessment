variable "project" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (devel, stage, prod)"
  type        = string
}

variable "s3_bucket_domain" {
  description = "S3 bucket domain name (from S3 module output)"
  type        = string
}

variable "log_bucket_domain" {
  description = "S3 domain for CloudFront logs"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class (PriceClass_100, 200, or All)"
  type        = string
  default     = "PriceClass_100"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for policy attachment"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for policy resource"
  type        = string
}