terraform {
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "what2play-infrastructure/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

data "aws_caller_identity" "current" {}

# create s3 bucket to host site
resource "aws_s3_bucket" "what2play_s3_bucket" {
	bucket  = "what2play"
}

# create cognito user pool
resource "aws_cognito_user_pool" "what2play_cognito_userpool" {
    name = "what2play_Users"
    username_attributes = ["email"]
    auto_verified_attributes = ["email"]
    password_policy {
        minimum_length = 8
        require_lowercase = true
        require_numbers = true
        require_symbols = true
        require_uppercase = true

    }
    mfa_configuration = "OFF"
    username_configuration {
        case_sensitive = false
    }

    device_configuration {
        device_only_remembered_on_user_prompt = true
    }
}

# resource "aws_cognito_user_pool_domain" "what2play_userpool_domain" {
#     domain          = "what2play.seanezell.com"
#     certificate_arn = "arn:aws:acm:us-east-1:736813861381:certificate/b225eb43-6514-478d-a42f-5c4d229f5bf1"
#     user_pool_id    = aws_cognito_user_pool.what2play_cognito_userpool.id
# }

resource "aws_cognito_user_pool_client" "what2play_cognito_userpool_client" {
    name = "what2play_Cognito_Client"
    user_pool_id = aws_cognito_user_pool.what2play_cognito_userpool.id
    allowed_oauth_flows_user_pool_client = true
    supported_identity_providers = ["COGNITO"]
    generate_secret = false
    explicit_auth_flows = ["ALLOW_USER_SRP_AUTH","ALLOW_USER_PASSWORD_AUTH","ALLOW_REFRESH_TOKEN_AUTH"]
    refresh_token_validity = "30"
    callback_urls = ["https://what2play.seanezell.com"]
    logout_urls = ["https://what2play.seanezell.com"]
    allowed_oauth_flows = ["code"]
    allowed_oauth_scopes = ["email","openid","aws.cognito.signin.user.admin"]
}