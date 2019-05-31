variable "name" {
  description = "API name"
}

variable "stage_name" {
  default = "Default"
}

variable "sub_domain" {}

variable "domain_certificate" {}

variable "certificate_arn" {}

variable "lambda_invoke_arn" {}
