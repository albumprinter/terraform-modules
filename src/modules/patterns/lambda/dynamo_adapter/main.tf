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

data "aws_iam_policy_document" "publish_to_sns_policy_document" {
  statement {
    resources = ["${var.topic_arn}"]
    effect    = "Allow"
    actions   = ["sns:Publish"]
  }
}

resource "aws_iam_policy" "publish_to_sns_policy" {
  name        = "${var.name}"
  description = "IAM policy for publishing to SNS from ${var.name}."
  policy      = "${data.aws_iam_policy_document.publish_to_sns_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
  role       = "${module.app.role_name}"
  policy_arn = "${aws_iam_policy.publish_to_sns_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = "${module.app.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
}

resource "aws_lambda_event_source_mapping" "app" {
  depends_on        = ["aws_iam_role_policy_attachment.dynamodb_policy_attachment"]
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
    TOPIC_ARN = "${var.topic_arn}"
  }
}
