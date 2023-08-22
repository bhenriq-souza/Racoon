terraform {
  source = "../../../../common/modules//dynamodb/table"
}

locals {
  env_vars     = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars = yamldecode(file(find_in_parent_folders("account.yaml")))
}

inputs = {
  table_name   = "${local.env_vars.project}-users-${local.env_vars.env}"
  hash_key     = "email"
}
