locals {
  log_group_name = "${var.log_group_prefix}${var.app_name}"
}

module "error_topic" {
  source = "../../resources/sns/plain"
  name   = "${var.app_name}-Errors"
  tags   = "${var.tags}"
}

module "email_subscriptions" {
  source        = "../../resources/sns/email_subscription"
  sns_topic_arn = "${module.error_topic.arn}"
  emails        = "${var.emails}"
}

module "log_group" {
  source            = "../../resources/cw/log_group"
  name              = "${local.log_group_name}"
  retention_in_days = "${var.log_retention_days}"
  tags              = "${var.tags}"
}

module "metric_filter" {
  source         = "../../resources/cw/metric_filter"
  name           = "${var.app_name}-ErrorMetricFilter"
  pattern        = "ERROR"
  log_group_name = "${module.log_group.name}"
}

module "metric_alarm" {
  source              = "../../resources/cw/metric_alarm"
  alarm_name          = "${var.app_name}-ErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.app_name}-ErrorMetric"
  period              = "3600"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "This metric alerts on ${var.app_name} errors"
  alarm_actions       = ["${module.error_topic.arn}"]
}
