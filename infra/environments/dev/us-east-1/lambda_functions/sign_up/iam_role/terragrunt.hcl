include {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/lambda_functions/sign_up/iam_role.hcl"
}
