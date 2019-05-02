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
  key    = "${local.app_name}"
  bucket = "${var.temp_bucket}"
  source = "${path.module}/publish/index.zip"
  tags   = "${var.tags}"
}

resource "aws_lambda_event_source_mapping" "example" {
  function_name     = "${module.app.arn}"
  event_source_arn  = "${var.event_source_arn}"
  batch_size        = "${var.batch_size}"
  starting_position = "TRIM_HORIZON"
}

module "app" {
  source         = "../with_error_alerts"
  name           = "${local.name}"
  s3_bucket_name = "${local.bucket}"
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
