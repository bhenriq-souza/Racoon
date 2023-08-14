include {
  path = find_in_parent_folders()
}

include "repo" {
  path = "${dirname(find_in_parent_folders())}/common/lambda_images_repository.hcl"
}
