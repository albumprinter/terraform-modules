variable "name" {
  description = "API name"
}

variable "stage_name" {
  default = "Default"
}

variable "domain" {
}

variable "zone_id" {
}

variable "lambda_invoke_arn" {
}

variable "tags" {
  type = map(string)
}

variable "enable_swagger_key"{
  type = bool
  default = false
}

variable "swagger_api_key" {
  description = "Swagger API Key for the Lambda function"
  type = string
}