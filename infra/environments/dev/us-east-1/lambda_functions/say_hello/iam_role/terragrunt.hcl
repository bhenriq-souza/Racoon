include {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/lambda_functions/say_hello/iam_role.hcl"
}
