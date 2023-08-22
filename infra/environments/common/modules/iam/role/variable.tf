variable "role_name" {
  description = "The name of the IAM Role to be created."
  type        = string
}

variable "assume_role_policy" {
  description = "The policy that the role should assume."
  type        = string
}

variable "description" {
  description = "Description of the IAM role."
  type        = string
  default     = "This is a role"
}

variable "path" {
  description = "Path in which to create the role."
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "The ARN of the policy used to set the permissions boundary for the role."
  type        = string
  default     = null
}

variable "policy" {
  description = "The IAM policy to be attached to the role."
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy to be created."
  type        = string
}

variable "policies_arns" {
  description = "List of ARNs of IAM policies to attach to the role."
  type        = list(string)
  default     = []
}
