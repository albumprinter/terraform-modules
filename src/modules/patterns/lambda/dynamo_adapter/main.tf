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

data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
    ]

    resources = ["${var.event_source_arn}"]
  }
}

resource "aws_iam_policy" "app" {
  name        = "${var.name}"
  description = "IAM policy for streaming to DynamoDb adapter ${var.name}."
  policy      = "${data.aws_iam_policy_document.app.json}"
}

resource "aws_iam_policy_attachment" "app" {
  name       = "${var.name}"
  policy_arn = "${aws_iam_policy.app.arn}"
}

resource "aws_lambda_event_source_mapping" "app" {
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
  memory_size    = 128

  variables = {
    TOPIC_ARN = "${var.topic_arn}"
  }
}
