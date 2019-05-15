output "kinesis_arn" {
  value       = "${module.stream.arn}"
  description = "Firehose stream ARN."
}

output "write_policy_arn" {
  value       = "${module.write_policy.arn}"
  description = "The ARN of the write to Firehose stream policy."
}
