output "arn" {
  value = "${element(concat(aws_lambda_function.app.*.arn, list("")), 0)}"
}

output "qualified_arn" {
  value = "${element(concat(aws_lambda_function.app.*.qualified_arn, list("")), 0)}"
}

output "invoke_arn" {
  value = "${element(concat(aws_lambda_function.app.*.invoke_arn, list("")), 0)}"
}
