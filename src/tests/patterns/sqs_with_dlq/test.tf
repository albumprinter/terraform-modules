provider "aws" {
  region = "eu-west-1"
}

module "test" {
  source = "../../../modules/patterns/sqs_with_dlq"
  name   = "test-sqs-with-dlq"
  tags   = {}
}
