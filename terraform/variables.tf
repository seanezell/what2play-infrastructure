variable "what2play_bucket_name" {
    type        = string
    description = "S3 bucket name used as the CloudFront origin"
}

variable "domain_name" {
    type        = string
    default     = "what2play.seanezell.com"
}