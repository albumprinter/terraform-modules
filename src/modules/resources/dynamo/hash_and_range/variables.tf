variable "name" {}

variable "stream_enabled" {
  default = false
}

variable "stream_view_type" {
  default = "NEW_AND_OLD_IMAGES"
}

variable "hash_key" {}

variable "range_key" {}

variable "tags" {
  type = "map"
}
