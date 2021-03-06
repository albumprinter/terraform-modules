terraform {
  required_version = ">= 0.12"
}

data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = ["${var.s3_bucket_arn}", "${var.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "app" {
  name        = var.policy_name
  description = "Grant full access to specific S3 bucket"
  policy      = data.aws_iam_policy_document.app.json
}
