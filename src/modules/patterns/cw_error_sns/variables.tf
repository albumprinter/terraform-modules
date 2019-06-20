variable "app_name" {
  description = "(Requred) Name used for entities like lambda, IAM role etc. For consistency with suffixes, use CamelCase."
}

variable "log_group_prefix" {
  description = "(Requred) Prefix for log group name."
}

variable "emails" {
  type        = "list"
  description = "(Requred) Emails for notification in case of errors"
}

variable "tags" {
  type = "map"
}

variable "log_retention_days" {
  description = "(Optional) Cloudwatch logs retention."
  default     = "30"
}
