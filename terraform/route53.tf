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