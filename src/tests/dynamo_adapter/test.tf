provider "aws" {
  region = "eu-west-1"
}

locals {
  app_name = "test_lambda_dynamo_sns_${uuid()}"
}

module "label" {
  source      = "../../modules/resources/label"
  application = "${local.app_name}"
  name        = "app"
  environment = "test"
  domain      = "ci-cd platform"
  cost_center = "3600"
  team        = "customer care technology"
}

resource "aws_dynamodb_table" "test_table" {
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

module "test_sns2sqs" {
  source = "../../modules/patterns/sns_to_sqs_with_dlq"
  name   = "${local.app_name}"
}

module "test" {
  source     = "../../modules/patterns/lambda/dynamo_adapter"
  stream_arn = "${aws_dynamodb_table.test_table.stream_arn}"
  sns_arn    = "${module.test_sns2sqs.sns_arn}"
  tags       = "${label.tags}"
}
