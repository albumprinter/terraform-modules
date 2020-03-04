module "dlq" {
  source                    = "../../../resources/sqs/plain"
  name                      = "${var.name}-${var.dlq_suffix}"
  message_retention_seconds = 1209600 # Max
  max_message_size          = 262144  # Max
  tags                      = var.tags
}

module "sns_publisher_policy" {
  source      = "../../../resources/iam/sns_publisher"
  policy_name = "${var.name}-SNS"
  topics_arn  = [var.topic_arn]
}

module "dlq_publisher_policy" {
  source      = "../../../resources/iam/sqs_publisher"
  policy_name = "${var.name}-DLQ"
  queues_arn  = [module.dlq.arn]
}

module "stream_policy" {
  source      = "../../../resources/iam/dynamodb_stream"
  policy_name = "${var.name}-Stream"
  stream_arn  = var.event_source_arn
}

resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
  role       = module.app.role_name
  policy_arn = module.sns_publisher_policy.arn
}

resource "aws_iam_role_policy_attachment" "dlq_policy_attachment" {
  role       = module.app.role_name
  policy_arn = module.dlq_publisher_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = module.app.role_name
  policy_arn = module.stream_policy.arn
}

module "app" {
  source       = "../with_error_alerts"
  name         = var.name
  filepath     = "${path.module}/package.zip"
  handler      = "index.handler"
  runtime      = "nodejs10.x"
  emails       = var.emails
  description  = var.description
  tags         = var.tags
  memory_size  = 256
  alert_period = var.alert_period

  max_concurrent_executions = var.max_concurrent_executions

  variables = {
    TOPIC_ARN = var.topic_arn
  }
}

resource "aws_lambda_event_source_mapping" "app" {
  event_source_arn  = var.event_source_arn
  function_name     = module.app.lambda_arn
  starting_position = "TRIM_HORIZON"

  maximum_record_age_in_seconds = 604800 # maximum

  batch_size             = var.batch_size
  parallelization_factor = var.parallelization_factor
  maximum_retry_attempts = var.maximum_retry_attempts

  bisect_batch_on_function_error = var.bisect_batch_on_function_error

  destination_config {
    on_failure {
      destination_arn = module.dlq.arn
    }
  }
}

