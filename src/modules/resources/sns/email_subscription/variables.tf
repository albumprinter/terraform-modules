variable "sns_topic_arn" {
  description = "(Requred) SNS topic to subscribe."
}

variable "emails" {
  type        = "list"
  description = "(Requred) Emails to notify."
}

variable "region" {
  default     = "eu-west-1"
  description = "(Optional) The region to use."
}
