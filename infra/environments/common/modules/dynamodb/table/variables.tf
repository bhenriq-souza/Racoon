variable "table_name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput."
  type        = string
  default     = "PROVISIONED"
}

variable "hash_key" {
  description = "The attribute to use as the hash key. Must also be defined as an attribute."
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range key. Must also be defined as an attribute."
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "The number of read units for this table. Must be set when billing_mode is PROVISIONED."
  type        = number
  default     = 5  # default to a small number, adjust as needed
}

variable "write_capacity" {
  description = "The number of write units for this table. Must be set when billing_mode is PROVISIONED."
  type        = number
  default     = 5  # default to a small number, adjust as needed
}