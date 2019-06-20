variable "name" {
  description = "The name of the log group. If omitted, Terraform will assign a random, unique name."
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = "map"
}

variable "retention_in_days" {
  default     = -1
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group."
}

variable "kms_key_id" {
  default     = ""
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data."
}
