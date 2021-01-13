terraform {
  required_version = ">= 0.12"
}

resource "aws_iam_role" "app" {
  name        = var.name
  description = var.description

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = var.tags
}

module "log_group" {
  source = "../../../resources/cw/log_group"

  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.name}-Logging"
  description = "IAM policy for logging from a lambda ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${module.log_group.arn}:*",
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

module "lambda" {
  source = "../../../resources/lambda/plain"

  name           = var.name
  description    = var.description
  role_arn       = aws_iam_role.app.arn
  filepath       = var.filepath
  s3_bucket_name = var.s3_bucket_name
  s3_bucket_path = var.s3_bucket_path
  handler        = var.handler
  runtime        = var.runtime
  memory_size    = var.memory_size
  timeout        = var.timeout
  variables      = var.variables
  logs_arn       = module.log_group.arn
  vpc_config     = var.vpc_config

  max_concurrent_executions = var.max_concurrent_executions

  tags = var.tags
}

