# What 2 Play Infrastructure

Infrastructure-as-code for the What 2 Play app, focused on shared cloud foundations: static hosting edge, auth, DNS, deployment access, and supporting trigger logic.

## Project Breadcrumbs

What 2 Play is split across multiple repos with distinct responsibilities:

- [`what2play`](https://github.com/seanezell/what2play): pseudo-parent repo for high-level docs and portfolio entrypoint
- [`what2play-infrastructure`](https://github.com/seanezell/what2play-infrastructure) (this repo): Terraform-managed shared AWS infrastructure
- [`what2play-services`](https://github.com/seanezell/what2play-services): API Gateway + application Lambdas + service data resources
- [`what2play-client`](https://github.com/seanezell/what2play-client): React web app

## What This Repo Owns

- S3 + CloudFront hosting foundation for the web app domain
- Route53 DNS records for app and auth subdomains
- Cognito User Pool, app client, and hosted UI domain
- Post-confirmation Cognito trigger Lambda packaging/deployment
- IAM for Lambda runtime and GitHub Actions OIDC deploy role
- Terraform remote state backend configuration (S3 + DynamoDB reference)

## Repository Structure

- `terraform/`: root Terraform configuration for this stack
- `lambdas/what2play-post-confirmation/`: Node.js Lambda source + unit tests
- `.github/workflows/terraform-deploy.yml`: CI workflow that runs Lambda tests, then Terraform plan/apply

## Deployment and CI

Deployments run via GitHub Actions in `.github/workflows/terraform-deploy.yml`:

1. Run unit tests for the Cognito post-confirmation Lambda
2. Run `terraform fmt`, `terraform init`, `terraform validate`, and `terraform plan`
3. Apply changes on `main`

### Workflow Triggers

- Pushes to `main` when files change under `terraform/**` or `lambdas/**`
- Manual `workflow_dispatch`

## Local Development

### Terraform

```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file variables/terraform.tfvars -var "route53_zone_id=<YOUR_ZONE_ID>"
```

### Lambda Unit Tests

```bash
cd lambdas/what2play-post-confirmation
npm install
npm test
```

## Notes

- Business APIs, domain logic, and DynamoDB application modeling are intentionally outside this repo and live in `what2play-services`.
- Frontend app code and deployment concerns beyond shared infra live in `what2play-client`.

## License

Private portfolio project. Sharing details privately for interviews is welcome.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.28.0 |
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | 6.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.what2play](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.what2play_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cognito_user_pool.what2play_cognito_userpool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.what2play_cognito_userpool_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.what2play_userpool_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_iam_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions_terraform_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.post_confirmation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.cognito_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.what2play](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.what2play_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.what2play_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudfront_cache_policy.caching_optimized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the website | `string` | `"what2play.seanezell.com"` | no |
| <a name="input_dynamo_table_name"></a> [dynamo\_table\_name](#input\_dynamo\_table\_name) | Name of the DynamoDB table for storing game data | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Hosted Zone ID for seanezell.com (created in account-level infrastructure) | `string` | n/a | yes |
| <a name="input_what2play_bucket_name"></a> [what2play\_bucket\_name](#input\_what2play\_bucket\_name) | S3 bucket used as the CloudFront origin | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain"></a> [cloudfront\_distribution\_domain](#output\_cloudfront\_distribution\_domain) | CloudFront distribution domain name |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | CloudFront distribution ID (for cache invalidation) |
| <a name="output_cognito_client_id"></a> [cognito\_client\_id](#output\_cognito\_client\_id) | Cognito App Client ID |
| <a name="output_cognito_hosted_ui_domain"></a> [cognito\_hosted\_ui\_domain](#output\_cognito\_hosted\_ui\_domain) | Cognito Hosted UI domain URL |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | Cognito User Pool ID |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name for website hosting |
<!-- END_TF_DOCS -->