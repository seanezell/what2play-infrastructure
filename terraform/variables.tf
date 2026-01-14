variable "what2play_bucket_name" {
  type        = string
  description = "S3 bucket used as the CloudFront origin"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the website"
  default     = "what2play.seanezell.com"
}

variable "route53_zone_id" {
    description = "Hosted Zone ID for seanezell.com (created in account-level infrastructure)"
    type        = string
}