terraform {
  source = "../../../../../common/modules//lambda_function"
}

locals {
  env_vars      = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars  = yamldecode(file(find_in_parent_folders("account.yaml")))
  region_vars   = yamldecode(file(find_in_parent_folders("region.yaml")))
}

dependency "iam_role" {
  config_path = "../iam_role"
}

dependency "kms_key" {
  config_path = "../../../kms_encryption_keys/users"
}

inputs = {
  environment        = local.env_vars.env
  function_name      = "${local.env_vars.project}_sign_up_function"
  image_uri          = "${local.account_vars.aws_account_id}.dkr.ecr.${local.region_vars.aws_region}.amazonaws.com/${local.env_vars.project}-images-repository-${local.env_vars.env}:${local.env_vars.project}_sign_up"
  role               = dependency.iam_role.outputs.role_arn
  enable_api_gateway = true
  api_name           = "${local.env_vars.project}_sign_up-api"
  region             = local.region_vars.aws_region
  account_id         = local.account_vars.aws_account_id
  
  environment_variables = {
    "ENV": local.env_vars.env,
    "POWERTOOLS_SERVICE_NAME": "${local.env_vars.project}_sign_up",
    "LOG_LEVEL": local.env_vars.env == "prod" ? "INFO" : "DEBUG",
    "USERS_TABLE": "${local.env_vars.project}-users-${local.env_vars.env}"
    "KMS_USERS_KEY_ALIAS": dependency.kms_key.outputs.kms_key_alias,
    "AWS_REGION_NAME": local.region_vars.aws_region
  }
}
