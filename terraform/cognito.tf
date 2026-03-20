# create cognito user pool
resource "aws_cognito_user_pool" "what2play_cognito_userpool" {
  name                     = "what2play_Users"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  password_policy {
    minimum_length                   = 6
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  mfa_configuration = "OFF"
  username_configuration {
    case_sensitive = false
  }

  device_configuration {
    device_only_remembered_on_user_prompt = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  lambda_config {
    post_confirmation = aws_lambda_function.post_confirmation.arn
  }
}

resource "aws_cognito_user_pool_domain" "what2play_userpool_domain" {
  domain          = "what2play-auth.seanezell.com"
  certificate_arn = data.aws_acm_certificate.issued.arn
  user_pool_id    = aws_cognito_user_pool.what2play_cognito_userpool.id
}

resource "aws_cognito_user_pool_client" "what2play_cognito_userpool_client" {
  name                                 = "what2play_Cognito_Client"
  user_pool_id                         = aws_cognito_user_pool.what2play_cognito_userpool.id
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
  generate_secret                      = false
  explicit_auth_flows                  = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  refresh_token_validity               = 30
  callback_urls                        = ["https://${var.domain_name}", "https://${var.domain_name}/"]
  logout_urls                          = ["https://${var.domain_name}", "https://${var.domain_name}/"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  prevent_user_existence_errors        = "ENABLED"
  read_attributes                      = ["email", "email_verified"]
  write_attributes                     = ["email"]
}