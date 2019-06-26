data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
    ]

    resources = ["${var.dynamo_table_arn}"]
  }
}

resource "aws_iam_policy" "app" {
  name        = "${var.policy_name}"
  description = "Grant read access to specific DynamoDB table stream."
  policy      = "${data.aws_iam_policy_document.app.json}"
}
