data "aws_iam_policy_document" "app" {
  version = "2012-10-17"

  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessageBatch",
      "sqs:SendMessageBatch",
      "sqs:SendMessage",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:SetQueueAttributes",
    ]

    resources = ["${var.queues_arn}"]
  }
}

resource "aws_iam_policy" "app" {
  name        = "${var.policy_name}"
  description = "Allows write messages to specific queue(s)"
  policy      = "${data.aws_iam_policy_document.app.json}"
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = "${var.role_name}"
  policy_arn = "${aws_iam_policy.app.arn}"
}
