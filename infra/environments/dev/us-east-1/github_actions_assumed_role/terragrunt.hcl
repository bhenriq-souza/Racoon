include {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/github_actions_assumed_role.hcl"
}