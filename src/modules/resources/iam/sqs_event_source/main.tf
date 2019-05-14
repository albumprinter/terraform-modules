module "app" {
  source      = "../sqs_subscriber"
  policy_name = "${var.subscriber_policy_name}"
  role_name   = "${var.lambda_role_name}"
  queues_arn  = ["${var.queue_arn}"]
}

resource "aws_lambda_event_source_mapping" "app" {
  depends_on       = ["module.app"]
  event_source_arn = "${var.queue_arn}"
  function_name    = "${var.lambda_arn}"
  batch_size       = "${var.batch_size}"
}
