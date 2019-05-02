variable "name" {
  description = "(Required) Name used for entities like lambda, IAM role etc. For consistency with suffixes, use CamelCase."
}

variable "event_source_arn" {
  description = "(Required) The event source ARN - can either be a Kinesis or DynamoDB stream."
}

variable "topic_arn" {
  description = "(Required) SNS topic you want to publish to."
}

variable "temp_bucket" {
  description = "(Required) The name of a temp bucket for deployment process."
}

variable "tags" {
  type        = "map"
  description = "A mapping of tags to assign to the resource."
}

variable "emails" {
  type        = "list"
  description = "(Required) Emails for notification in case of errors"
}

variable "batch_size" {
  default     = 100
  description = "(Optional) The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 100 for DynamoDB and Kinesis, 10 for SQS."
}

variable "description" {
  default     = ""
  description = "(Optional) Lambda description"
}
