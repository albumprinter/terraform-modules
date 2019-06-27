output "arn" {
  value = "${aws_lambda_function.app.0.arn}"
}

output "qualified_arn" {
  value = "${aws_lambda_function.app.0.qualified_arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.app.0.invoke_arn}"
}
