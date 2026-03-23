# create s3 bucket to host site
resource "aws_s3_bucket" "what2play_s3_bucket" {
  bucket = var.what2play_bucket_name

  tags = {
    Name = "what2play-bucket-${var.what2play_bucket_name}"
    Env  = "prod"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.what2play_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Give CloudFront OAI read access to bucket objects
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.what2play_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = ["s3:GetObject"]
        Resource = [
          "${aws_s3_bucket.what2play_s3_bucket.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.what2play.arn
          }
        }
      }
    ]
  })
}

locals {
  origin_id = "s3-${var.what2play_bucket_name}"
}

data "aws_acm_certificate" "issued" {
  provider    = aws.global
  domain      = "*.seanezell.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_origin_access_control" "what2play_oac" {
  name                              = "what2play-oac"
  description                       = "OAC for what2play-content bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always" # or "no-override" if you prefer
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "what2play" {
  enabled             = true
  comment             = var.domain_name
  price_class         = "PriceClass_100" # US, Canada
  default_root_object = "index.html"
  aliases             = [var.domain_name]
  is_ipv6_enabled     = true

  origin {
    domain_name = "${var.what2play_bucket_name}.s3.us-west-2.amazonaws.com"
    origin_id   = local.origin_id

    origin_access_control_id = aws_cloudfront_origin_access_control.what2play_oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id
    cache_policy_id  = data.aws_cloudfront_cache_policy.caching_optimized.id

    viewer_protocol_policy = "redirect-to-https"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.domain_name}"
    Env  = "prod"
  }
}

# what2play records
resource "aws_route53_record" "what2play" {
  zone_id = var.route53_zone_id
  name    = "what2play"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.what2play.domain_name
    zone_id                = aws_cloudfront_distribution.what2play.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "what2play_auth" {
  zone_id = var.route53_zone_id
  name    = "what2play-auth"
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.what2play_userpool_domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.what2play_userpool_domain.cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}
