# Create zip file from Lambda code
data "archive_file" "lambda_zip" {
  type             = "zip"
  source_dir       = "${path.module}/../lambdas/what2play-post-confirmation"
  output_file_mode = "0666"
  output_path      = "${path.module}/zip/post-confirmation.zip"
}

# Lambda function for post-confirmation trigger
resource "aws_lambda_function" "post_confirmation" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "what2play-post-confirmation"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs22.x"
  timeout          = 30
  memory_size      = 128
  publish          = true

  depends_on = [data.archive_file.lambda_zip]
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.post_confirmation.function_name}"
  retention_in_days = 14
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "what2play-post-confirmation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "what2play-post-confirmation-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/what2play"
      }
    ]
  })
}

# Permission for Cognito to invoke Lambda
resource "aws_lambda_permission" "cognito_invoke" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_confirmation.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.what2play_cognito_userpool.arn
}
