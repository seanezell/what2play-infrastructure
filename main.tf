terraform {
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "what2play-infrastructure/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

data "aws_caller_identity" "current" {}

# create iam role & policy for what2play (or do I do that at a api level?)
resource "aws_iam_policy" "policy" {
    name = "what2play_policy"
    path = "/" 
    policy = data.aws_iam_policy_document.policyDoc.json
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = [
            "sts:AssumeRole",
        ]
    
        effect = "Allow"
        principals {
            identifiers = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
            type = "Service"
        }
    }
}

resource "aws_iam_role" "role" {
    name = "what2play_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "name" {
    role = aws_iam_role.role.name
    policy_arn = aws_iam_policy.policy.arn
}

data "aws_iam_policy_document" "policyDoc" {
    statement {
        sid    = "s3access"
        effect = "Allow"
        actions   = ["s3:*"]
        resources = ["${aws_s3_bucket.what2play_s3_bucket.arn}", "${aws_s3_bucket.what2play_s3_bucket.arn}/*"]
    }
}





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