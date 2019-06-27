output "arn" {
  value = "${var.filepath == "" ? module.fromS3.arn : module.fromFile.arn}"
}

output "qualified_arn" {
  value = "${var.filepath == "" ? module.fromS3.qualified_arn : module.fromFile.qualified_arn}"
}

output "invoke_arn" {
  value = "${var.filepath == "" ? module.fromS3.invoke_arn : module.fromFile.invoke_arn}"
}
