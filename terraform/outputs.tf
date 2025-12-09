output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.what2play_cognito_userpool.id
  description = "Cognito User Pool ID"
}

output "cognito_client_id" {
  value       = aws_cognito_user_pool_client.what2play_cognito_userpool_client.id
  description = "Cognito App Client ID"
}

output "cognito_hosted_ui_domain" {
  value       = "https://${aws_cognito_user_pool_domain.what2play_userpool_domain.domain}"
  description = "Cognito Hosted UI domain URL"
}

output "cloudfront_distribution_domain" {
  value       = aws_cloudfront_distribution.website.domain_name
  description = "CloudFront distribution domain name"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.website.id
  description = "CloudFront distribution ID (for cache invalidation)"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.what2play_s3_bucket.id
  description = "S3 bucket name for website hosting"
}
