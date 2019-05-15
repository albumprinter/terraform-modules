variable "input" {
  type        = "list"
  description = "Input array of strings"
}

variable "suffix" {
  default     = "/*"
  description = "value to concat"
}

variable "delimiter" {
  default     = "|||"
  description = "should be unique and any element should not contain this value"
}

locals {
  suffix_with_delimiter = "${var.suffix}${var.delimiter}"
}

locals {
  # We add first item in the end so result will be like "item1+|||item2+|||item1"
  joied_values = "${join(local.suffix_with_delimiter, concat(var.input, list(var.input[0])))}"
}

locals {
  splitted = "${compact(split(var.delimiter, local.joied_values))}"
}

locals {
  concantanated_array = "${concat(var.input, local.splitted)}"
}

output "new_array" {
  value = "${local.splitted}"
}

output "concantanated_array" {
  value = "${local.concantanated_array}"
}
