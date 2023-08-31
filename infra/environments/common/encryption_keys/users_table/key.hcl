terraform {
  source = "../../../../common/modules//kms"
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars = yamldecode(file(find_in_parent_folders("account.yaml")))
}

dependency "role" {
  config_path =  "../../lambda_functions/sign_up/iam_role"
}

inputs = {
  description         = "KMS key for encrypting DynamoDB Users table"
  enable_key_rotation = true
  create_alias        = true
  alias_name          = "alias/${local.env_vars.project}-users-encrypt-${local.env_vars.env}"
  account_id          = local.account_vars.aws_account_id
  role_arn            = dependency.role.outputs.role_arn
}
