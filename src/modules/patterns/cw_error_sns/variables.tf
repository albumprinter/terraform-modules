variable "app_name" {
  description = "(Required) Name used for entities like lambda, IAM role etc. For consistency with suffixes, use CamelCase."
}

variable "log_group_prefix" {
  description = "(Required) Prefix for log group name."
}

variable "emails" {
  type        = "list"
  description = "(Required) Emails for notification in case of errors"
}

variable "tags" {
  type = "map"
}

variable "log_retention_days" {
  description = "(Optional) Cloudwatch logs retention."
  default     = "30"
}
