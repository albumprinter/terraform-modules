module "lambda" {
  source         = "../with_cw_logs"
  name           = "${var.name}"
  description    = "${var.description}"
  s3_bucket_name = "${var.s3_bucket_name}"
  s3_bucket_path = "${var.s3_bucket_path}"
  handler        = "${var.handler}"
  runtime        = "${var.runtime}"
  memory_size    = "${var.memory_size}"
  timeout        = "${var.timeout}"
  variables      = "${var.variables}"

  log_retention_days = "${var.log_retention_days}"

  max_concurrent_executions = -1

  tags = "${var.tags}"
}

module "api" {
  source = "../../api_gateway/all_path"

  name               = "${var.name}"
  sub_domain         = "${var.sub_domain}"
  domain_certificate = "${var.domain_certificate}"
  certificate_arn    = "${var.certificate_arn}"
  lambda_invoke_arn  = "${module.lambda.lambda_invoke_arn}"
}
