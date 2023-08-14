terraform {
  source = "../../../common/modules//ecr"
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

inputs = {
  name = "racoon-images-repository-${local.env_vars.env}"
}
