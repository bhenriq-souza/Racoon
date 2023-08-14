terraform {
  source = "../../../common/modules//lambda_function"
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

inputs = {
  name = "say-hello"
}