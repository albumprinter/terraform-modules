resource "null_resource" "depends_on" {
  triggers {
    depends_on = "${join("", var.depends_on)}"
  }
}

resource "aws_cloudwatch_log_metric_filter" "app" {
  depends_on = ["null_resource.depends_on"]

  name           = "${var.name}"
  pattern        = "${var.pattern}"
  log_group_name = "${var.log_group_name}"

  metric_transformation {
    name          = "${var.name}_Transformation"
    namespace     = "${var.transformation_namespace}"
    value         = "${var.transformation_value}"
    default_value = "${var.transformation_default_value}"
  }
}
