data "archive_file" "zip" {
  type        = "zip"
  source_file = "${var.filepath}"
  output_path = "${path.cwd}/publish/package.zip"
}

resource "aws_lambda_function" "app" {
  count         = "${var.count}"
  function_name = "${var.name}"
  description   = "${var.description}"
  role          = "${var.role_arn}"
  handler       = "${var.handler}"
  runtime       = "${var.runtime}"
  memory_size   = "${var.memory_size}"
  timeout       = "${var.timeout}"
  filename      = "${path.cwd}/publish/package.zip"

  reserved_concurrent_executions = "${var.max_concurrent_executions}"

  environment {
    variables = "${var.variables}"
  }

  tags = "${var.tags}"
}
