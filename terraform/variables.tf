variable "what2play_bucket_name" {
  type        = string
  description = "S3 bucket used as the CloudFront origin"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the website"
  default     = "what2play.seanezell.com"
}

variable "dynamo_table_name" {
  type        = string
  description = "Name of the DynamoDB table for storing game data"
}

variable "route53_zone_id" {
  type        = string
  description = "Hosted Zone ID for seanezell.com (created in account-level infrastructure)"
}