output "kms_key_id" {
  description = "The globally unique identifier for the KMS key."
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key."
  value       = aws_kms_key.this.arn
}

output "kms_key_alias" {
  description = "The display name of the alias."
  value       = aws_kms_alias.this[0].name
  depends_on  = [aws_kms_alias.this]
}
