resource "aws_dynamodb_table" "app" {
  name             = "${var.name}"
  stream_enabled   = "${var.stream_enabled}"
  stream_view_type = "${var.stream_view_type}"
  billing_mode     = "PAY_PER_REQUEST"         # it is a better option in 99%, except high-load (24/7)
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"

  attribute = [
    {
      name = "${var.hash_key}"
      type = "S"
    },
    {
      name = "${var.range_key}"
      type = "S"
    },
  ]

  tags = "${var.tags}"
}
