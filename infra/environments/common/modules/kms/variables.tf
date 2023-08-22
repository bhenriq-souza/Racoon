variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = "KMS key created by Terraform"
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled."
  type        = bool
  default     = true
}

variable "create_alias" {
  description = "Specifies whether to create a KMS key alias."
  type        = bool
  default     = false
}

variable "alias_name" {
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash."
  type        = string
}

variable "role_arn" {
  description = "The IAM role arn that will have permissions to use the KMS key."
  type        = string
}

variable "account_id" {
  description = "The AWS account ID."
  type        = string
}
