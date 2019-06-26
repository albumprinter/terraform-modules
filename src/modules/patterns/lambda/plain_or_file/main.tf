module "plain" {
  count                     = "${var.filepath == "" ? 1 : 0}"
  source                    = "../../../resources/lambda/plain"
  name                      = "${var.name}"
  description               = "${var.description}"
  role_arn                  = "${var.role_arn}"
  s3_bucket_name            = "${var.s3_bucket_name}"
  s3_bucket_path            = "${var.s3_bucket_path}"
  handler                   = "${var.handler}"
  runtime                   = "${var.runtime}"
  memory_size               = "${var.memory_size}"
  timeout                   = "${var.timeout}"
  max_concurrent_executions = "${var.max_concurrent_executions}"
  variables                 = "${var.variables}"
  tags                      = "${var.tags}"
}

module "file" {
  count                     = "${var.filepath != "" ? 1 : 0}"
  source                    = "../../../resources/lambda/file"
  name                      = "${var.name}"
  description               = "${var.description}"
  role_arn                  = "${var.role_arn}"
  filepath                  = "${var.filepath}"
  handler                   = "${var.handler}"
  runtime                   = "${var.runtime}"
  memory_size               = "${var.memory_size}"
  timeout                   = "${var.timeout}"
  max_concurrent_executions = "${var.max_concurrent_executions}"
  variables                 = "${var.variables}"
  tags                      = "${var.tags}"
}
