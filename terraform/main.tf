terraform {
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "what2play-infrastructure/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

data "aws_caller_identity" "current" {}