########################################
# Global Locals & Environment Context
########################################
locals {
  project     = var.project
  environment = var.environment
}

# ########################################
# # Provider Configuration
# ########################################
# provider "aws" {
#   region  = var.aws_region
#   profile = var.aws_profile
# }

########################################
# S3 Static Site Module
########################################
module "s3_static_site" {
  source = "../../modules/s3_static_site"

  project       = local.project
  environment   = local.environment
  log_bucket    = var.log_bucket
  sse_algorithm = var.sse_algorithm
  kms_key_id    = var.kms_key_id
}

########################################
# CloudFront CDN Module
########################################
module "cloudfront" {
  source = "../../modules/cloudfront"

  project           = local.project
  environment       = local.environment
  s3_bucket_domain  = module.s3_static_site.bucket_domain_name
  s3_bucket_name    = module.s3_static_site.bucket_name
  s3_bucket_arn     = module.s3_static_site.bucket_arn
  log_bucket_domain = "${var.log_bucket}.s3.amazonaws.com"
  price_class       = var.price_class
}
