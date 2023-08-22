resource "aws_iam_role" "role" {
  name                 = var.role_name
  assume_role_policy   = var.assume_role_policy
  path                 = var.path
  permissions_boundary = var.permissions_boundary != null ? var.permissions_boundary : null
}

resource "aws_iam_role_policy" "policy" {
  name   = var.policy_name
  role   = aws_iam_role.role.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length(var.policies_arns)
  role       = aws_iam_role.role.name
  policy_arn = var.policies_arns[count.index]
}