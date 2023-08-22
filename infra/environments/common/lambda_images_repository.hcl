terraform {
  source = "../../../common/modules//ecr"
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

inputs = {
  name = "${local.env_vars.project}-images-repository-${local.env_vars.env}"
}
