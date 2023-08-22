resource "aws_kms_key" "this" {
  description             = var.description
  enable_key_rotation     = var.enable_key_rotation
  is_enabled              = var.is_enabled

  policy                  = templatefile("${path.module}/policy-template.json.tpl", {
    ACCOUNT_ID = var.account_id,
    ROLE_ARN  = var.role_arn
  })
}

resource "aws_kms_alias" "this" {
  count                   = var.create_alias ? 1 : 0
  name                    = var.alias_name
  target_key_id           = aws_kms_key.this.key_id
}
