# what2play records
resource "aws_route53_record" "what2play" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = "what2play"
    type    = "CNAME"
    ttl     = 300
    records = ["d1kw9lwjtp0kgq.cloudfront.net"]
}

resource "aws_route53_record" "what2play_login" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = "what2play-login"
    type    = "CNAME"
    ttl     = 300
    records = ["dr8nq8l9uvgpd.cloudfront.net"]
}