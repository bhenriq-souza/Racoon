terraform {
  source = "../../../../../common/modules//iam/role"
}

locals {
  env_vars      = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars  = yamldecode(file(find_in_parent_folders("account.yaml")))
  region_vars   = yamldecode(file(find_in_parent_folders("region.yaml")))
}

inputs = {
  role_name = "say-hello_lambda_role"
  
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

  policy_name = "say-hello_lambda_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:${local.region_vars.aws_region}:${local.account_vars.aws_account_id}:log-group:/aws/lambda/*"
      }
    ]
  })
}
