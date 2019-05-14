variable "lambda_arn" {}

variable "lambda_role_name" {}

variable "subscriber_policy_name" {}

variable "queue_arn" {}

variable "batch_size" {
  default = 10
}
