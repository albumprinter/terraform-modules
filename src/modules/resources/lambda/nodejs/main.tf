resource "aws_lambda_function" "app" {
  function_name = "${var.name}"
  description   = "${var.description}"
  role          = "${var.role_arn}"
  handler       = "${var.handler}"
  runtime       = "nodejs10.x"
  memory_size   = "${var.memory_size}"
  timeout       = "${var.timeout}"
  filename      = "${var.filename}"

  reserved_concurrent_executions = "${var.max_concurrent_executions}"

  environment {
    variables = "${var.variables}"
  }

  tags = "${var.tags}"
}
