output "app_name" {
  value = "${var.app_name}"
}

output "lambda_arn" {
  value = "${module.lambda.arn}"
}
