variable "name" {
  description = "Lambda and API name"
}

variable "handler" {
  description = "The function entrypoint in your code."
}

variable "s3_bucket_name" {
  description = "Lambda source bucket (storage)"
}

variable "s3_bucket_path" {
  default     = ""
  description = "Path to artifact (zipped lambda)"
}

variable "runtime" {
  default     = "dotnetcore2.1"
  description = "The identifier of the function's runtime."
}

variable "description" {
  default     = ""
  description = "Lambda description"
}

variable "memory_size" {
  default     = "512"
  description = "Amount of memory in MB your Lambda Function can use at runtime."
}

variable "timeout" {
  default     = "30"
  description = "The amount of time your Lambda Function has to run in seconds."
}

variable "variables" {
  type = "map"

  default = {
    ENCODING = "utf-8"
  }
}

variable "log_retention_days" {
  type        = "string"
  description = "Cloudwatch logs retention"
  default     = "30"
}

variable "sub_domain" {}

variable "domain_certificate" {}

variable "tags" {
  type    = "map"
  default = {}
}