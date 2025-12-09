# create s3 bucket to host site
resource "aws_s3_bucket" "what2play_s3_bucket" {
	bucket  = var.what2play_bucket_name

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
            Principal = {
                AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
            }
            Action   = ["s3:GetObject", "s3:ListBucket"]
            Resource = [
                "${aws_s3_bucket.what2play_s3_bucket.arn}",
                "${aws_s3_bucket.what2play_s3_bucket.arn}/*"
            ]
        }
        ]
    })
}