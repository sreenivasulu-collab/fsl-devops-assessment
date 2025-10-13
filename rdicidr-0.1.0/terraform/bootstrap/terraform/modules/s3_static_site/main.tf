########################################
# S3 Static Site Module
########################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

########################################
# Random Suffix to Ensure Unique Bucket Names
########################################
resource "random_id" "suffix" {
  byte_length = 4
}

########################################
# Locals - Common Tags
########################################
locals {
  common_tags = {
    Project      = var.project
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Compliance   = "FullstackLabs"
    Name         = "${var.project}-${var.environment}-web"
  }
}

########################################
# S3 Bucket
########################################
resource "aws_s3_bucket" "this" {
  bucket        = "${var.project}-${var.environment}-web-${random_id.suffix.hex}"
  force_destroy = true

  tags = local.common_tags
}

########################################
# Ownership Controls
########################################
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

########################################
# Public Access Block
########################################
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

########################################
# Versioning
########################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

########################################
# Conditional Logging (safe cross-region logic)
########################################

# Try to read log bucket metadata (if exists)
data "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket
}

# Determine if same-region logging is allowed
locals {
  same_region_logging = try(data.aws_s3_bucket.log_bucket.region, "") == var.aws_region
}

# Enable logging only when safe
resource "aws_s3_bucket_logging" "logging" {
  count         = local.same_region_logging ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.log_bucket
  target_prefix = "${var.environment}/s3/"
}

########################################
# Encryption (AES256 or KMS)
########################################
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm != "" ? var.sse_algorithm : "AES256"
      kms_master_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }
}

########################################
# Lifecycle
########################################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "${var.environment}-cleanup-old-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
