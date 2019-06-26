output "arn" {
  value = "${var.filename == "" ? module.plain.arn : module.file.arn}"
}

output "qualified_arn" {
  value = "${var.filename == "" ? module.plain.qualified_arn : module.file.qualified_arn}"
}

output "invoke_arn" {
  value = "${var.filename == "" ? module.plain.invoke_arn : module.file.invoke_arn}"
}
