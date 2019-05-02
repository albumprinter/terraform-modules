output "arn" {
  value = "${aws_lambda_function.eventStream_lambda_proxyTo_sqs.arn}"
}
