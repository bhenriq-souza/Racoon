variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "URI of a Docker image in the Amazon ECR registry."
  type        = string
}

variable "role" {
  description = "IAM role attached to the Lambda Function"
  type        = string
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

# Optional API Gateway configuration
variable "enable_api_gateway" {
  description = "Whether to enable API Gateway integration"
  type        = bool
  default     = false
}

variable "api_name" {
  description = "The name of the API, used if enable_api_gateway is true"
  type        = string
  default     = ""
}

variable "api_method" {
  description = "The HTTP method to use for the API Gateway endpoint"
  type        = string
  default     = "ANY"
}

variable "api_gateway_authorization" {
  description = "The authorization type for the API Gateway method (e.g., NONE, AWS_IAM, CUSTOM, etc.)"
  type        = string
  default     = "NONE"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}