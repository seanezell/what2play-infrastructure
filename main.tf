terraform {
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "what2play-infrastructure/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

data "aws_caller_identity" "current" {}

# create cloudfront distro

# create edge lambda

# create route53 subdomain for what2play.seanezell.com

# create s3 bucket to host site
resource "aws_s3_bucket" "what2play_s3_bucket" {
	bucket  = "what2play"
}

# create dymamodb tables

# create cognito user pool

# create cognito authorizer app client/resource server