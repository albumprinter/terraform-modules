output "arn" {
  value       = "${aws_dynamodb_table.app.arn}"
  description = "The Amazon Resource Name (ARN) specifying the Table"
}

output "stream_arn" {
  value       = "${aws_dynamodb_table.app.stream_arn}"
  description = "The ARN of the Table Stream. Only available when stream_enabled = true"
}
