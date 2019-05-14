data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "sqs:DeleteMessage",
    ]

    resources = ["${var.queues_arn}"]
  }
}

resource "aws_iam_policy" "app" {
  name        = "${var.policy_name}"
  description = "Allows read messages from specific queue(s)"
  policy      = "${data.aws_iam_policy_document.app.json}"
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = "${var.role_name}"
  policy_arn = "${aws_iam_policy.app.arn}"
}
