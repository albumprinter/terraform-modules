locals {
  packagePath   = "${path.cwd}/publish/index.zip"
  packageSource = "${path.module}/index.js"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${local.packageSource}"
  output_path = "${local.packagePath}"
}

resource "aws_s3_bucket_object" "zip" {
  key    = "${var.name}"
  bucket = "${var.temp_bucket}"
  source = "${local.packagePath}"
  tags   = "${var.tags}"
}

module "dlq" {
  source                    = "../../../resources/sqs/plain"
  name                      = "${var.name}-ERROR"
  message_retention_seconds = 1209600                        # Max
  max_message_size          = 262144                         # Max
  tags                      = "${var.tags}"
}

module "sns_publisher_policy" {
  source      = "../../../resources/iam/sns_publisher"
  policy_name = "${var.name}-SNS"
  topics_arn  = ["${var.topic_arn}"]
}

module "dlq_publisher_policy" {
  source      = "../../../resources/iam/sqs_publisher"
  policy_name = "${var.name}-DLQ"
  queues_arn  = ["${module.dlq.arn}"]
}

module "stream_reader_policy" {
  source      = "../../../resources/iam/dynamodb_stream_reader"
  policy_name = "${var.name}-Stream-Reader"
  stream_arn  = "${var.event_source_arn}"
}

resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
  role       = "${module.app.role_name}"
  policy_arn = "${module.sns_publisher_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "dlq_policy_attachment" {
  role       = "${module.app.role_name}"
  policy_arn = "${module.dlq_publisher_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = "${module.app.role_name}"
  policy_arn = "${module.stream_reader_policy.arn}"
}

resource "aws_lambda_event_source_mapping" "app" {
  # depends_on        = ["module.stream_reader_policy"]
  function_name     = "${module.app.lambda_arn}"
  event_source_arn  = "${var.event_source_arn}"
  batch_size        = "${var.batch_size}"
  starting_position = "TRIM_HORIZON"
}

module "app" {
  source         = "../with_error_alerts"
  name           = "${var.name}"
  s3_bucket_name = "${var.temp_bucket}"
  s3_bucket_path = "${aws_s3_bucket_object.zip.id}"
  handler        = "index.handler"
  runtime        = "nodejs10.x"
  emails         = "${var.emails}"
  description    = "${var.description}"
  tags           = "${var.tags}"
  memory_size    = 512
  period         = "${var.period}"

  variables = {
    SUBJECT   = "${var.subject}"
    TOPIC_ARN = "${var.topic_arn}"
    DLQ_URL   = "${module.dlq.id}"
  }
}
