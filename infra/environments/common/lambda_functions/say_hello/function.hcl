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

inputs = {
  environment        = local.env_vars.env
  function_name      = "racoon_say_hello_function"
  image_uri          = "${local.account_vars.aws_account_id}.dkr.ecr.${local.region_vars.aws_region}.amazonaws.com/racoon-images-repository-${local.env_vars.env}:say_hello"
  role               = dependency.iam_role.outputs.role_arn
  enable_api_gateway = true
  api_name           = "racoon_say_hello-api"
  region             = local.region_vars.aws_region
  account_id         = local.account_vars.aws_account_id
  
  environment_variables = {
    "ENV": local.env_vars.env,
    "POWERTOOLS_SERVICE_NAME": "racoon_say_hello",
    "LOG_LEVEL": local.env_vars.env == "prod" ? "INFO" : "DEBUG",
  }
}
