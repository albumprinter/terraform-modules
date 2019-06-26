output "arn" {
  value = "${var.filepath == "" ? module.plain.arn : module.file.arn}"
}

output "qualified_arn" {
  value = "${var.filepath == "" ? module.plain.qualified_arn : module.file.qualified_arn}"
}

output "invoke_arn" {
  value = "${var.filepath == "" ? module.plain.invoke_arn : module.file.invoke_arn}"
}
