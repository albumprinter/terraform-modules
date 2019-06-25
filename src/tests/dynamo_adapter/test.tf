provider "aws" {
  region = "eu-west-1"
}

locals {
  name = "test_dynamo_to_sqs"
}

module "label" {
  source      = "../../modules/resources/label"
  application = "${local.name}"
  name        = "app"
  environment = "test"
  domain      = "ci-cd platform"
  cost_center = "3600"
  team        = "customer care technology"
}

resource "aws_dynamodb_table" "table" {
  name             = "${local.name}"
  hash_key         = "Id"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  stream_enabled   = true
  stream_view_type = "KEYS_ONLY"

  attribute = [
    {
      name = "Id"
      type = "S"
    },
  ]
}

module "sns_to_sqs" {
  source = "../../modules/patterns/sns_to_sqs_with_dlq"
  name   = "${local.name}"
  tags   = "${module.label.tags}"
}

module "test" {
  source           = "../../modules/patterns/lambda/dynamo_adapter"
  name             = "${local.name}"
  event_source_arn = "${aws_dynamodb_table.table.stream_arn}"
  topic_arn        = "${module.sns_to_sqs.sns_arn}"
  emails           = ["salavat.galiamov@albelli.com"]
  temp_bucket      = "cct-bo-temp-t"
  period           = 60
  tags             = "${module.label.tags}"
}
