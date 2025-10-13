########################################
# CloudFront CDN Module
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
# Locals - Common Tags
########################################
locals {
  common_tags = {
    Project      = var.project
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Compliance   = "FullstackLabs"
  }
}

########################################
# Random ID for Unique OAC Name
########################################
resource "random_id" "suffix" {
  byte_length = 4
}

########################################
# Origin Access Control
########################################
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project}-${var.environment}-oac-${random_id.suffix.hex}"
  description                       = "OAC for ${var.project}-${var.environment}-web"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

########################################
# CloudFront Distribution
########################################
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "${var.project}-${var.environment}-cdn"
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  price_class         = var.price_class

  origin {
    domain_name              = var.s3_bucket_domain
    origin_id                = "s3-${var.environment}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id         = "s3-${var.environment}-origin"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3.id
  }

  # logging_config {
  #   include_cookies = false
  #   bucket          = var.log_bucket_domain
  #   prefix          = "${var.environment}/cloudfront/"
  # }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version        = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-cdn"
  })
}

########################################
# Managed Policies (explicit data refs)
########################################
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3" {
  name = "Managed-CORS-S3Origin"
}

########################################
# S3 Bucket Policy Update for CloudFront OAC
########################################
resource "aws_s3_bucket_policy" "cloudfront_oac" {
  bucket = var.s3_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.this.id}"
          }
        }
      }
    ]
  })
}

########################################
# Data Sources
########################################
data "aws_caller_identity" "current" {}
