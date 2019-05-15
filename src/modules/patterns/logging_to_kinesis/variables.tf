variable "name" {}

variable "destination_bucket_name" {}

variable "buffer_interval_in_seconds" {
  default = 60
}

variable "buffer_size_in_mb" {
  default = 1
}

variable "tags" {
  type = "map"
}
