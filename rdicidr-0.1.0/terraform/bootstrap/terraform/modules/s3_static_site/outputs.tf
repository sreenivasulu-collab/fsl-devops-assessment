output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Regional domain name for CloudFront origin"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}