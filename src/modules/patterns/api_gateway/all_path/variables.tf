variable "name" {
  description = "API name"
}

variable "stage_name" {
  default = "Default"
}

variable "domain_name" {}

variable "zone_id" {}

variable "certificate_arn" {}

variable "lambda_invoke_arn" {}
