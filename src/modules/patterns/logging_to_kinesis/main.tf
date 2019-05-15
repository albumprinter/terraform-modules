module "destination_bucket" {
  source = "../../resources/s3/private_bucket"
  name   = "${var.destination_bucket_name}"
  tags   = "${var.tags}"
}

module "kinesis_role" {
  source      = "../../resources/iam/firehose_stream_to_s3"
  role_name   = "${var.name}-Kinesis"
  policy_name = "${var.name}-Kinesis-Write-To-S3"
  buckets     = ["${module.destination_bucket.arn}"]
}

module "stream" {
  source                     = "../../resources/firehose/s3_destination"
  name                       = "${var.name}"
  role_arn                   = "${module.kinesis_role.arn}"
  bucket_arn                 = "${module.destination_bucket.arn}"
  buffer_interval_in_seconds = "${var.buffer_interval_in_seconds}"
  buffer_size_in_mb          = "${var.buffer_size_in_mb}"
  tags                       = "${var.tags}"
}

module "write_policy" {
  source      = "../../resources/iam/firehose_write"
  stream_arn  = "${module.stream.arn}"
  policy_name = "${var.name}-Write-To-Kinesis"
}
