terraform {
  source = "../../../common/modules//iam/role"
}

locals {
  env_vars     = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars = yamldecode(file(find_in_parent_folders("account.yaml")))
}

inputs = {
  role_name = "ecr-repository-iam-role-${local.env_vars.env}"
  
  policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GithubOidcAuth",
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${local.account_vars.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": [
        "sts:TagSession",
        "sts:AssumeRoleWithWebIdentity"
      ],
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:bhenriq-souza/*:*"
        },
        "ForAllValues:StringEquals": {
          "token.actions.githubusercontent.com:iss": "http://token.actions.githubusercontent.com",
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "GithubOidcAuth",
#             "Effect": "Allow",
#             "Principal": {
#                 "Federated": "arn:aws:iam::768215981930:oidc-provider/token.actions.githubusercontent.com"
#             },
#             "Action": [
#                 "sts:TagSession",
#                 "sts:AssumeRoleWithWebIdentity"
#             ],
#             "Condition": {
#                 "StringLike": {
#                     "token.actions.githubusercontent.com:sub": "repo:fintalk-ai/*:*"
#                 },
#                 "ForAllValues:StringEquals": {
#                     "token.actions.githubusercontent.com:iss": "http://token.actions.githubusercontent.com",
#                     "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
#                 }
#             }
#         }
#     ]
# }