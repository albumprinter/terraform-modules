locals {
  log_group_name = "${var.log_group_prefix}${var.app_name}"
}

module "error_topic" {
  source = "../../resources/sns/plain"
  name   = "${var.app_name}-LogErrors"
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
  name           = "${var.app_name}-ErrorFilter"
  pattern        = "${var.pattern}"
  log_group_name = "${module.log_group.name}"
  depends_on     = ["${module.log_group.arn}"]
}

module "metric_alarm" {
  source              = "../../resources/cw/statistic_metric_alarm"
  alarm_name          = "${var.app_name}-ErrorAlarm"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.app_name}-ErrorMetric"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"
  alarm_description   = "This metric alerts on ${var.app_name} errors"
  alarm_actions       = ["${module.error_topic.arn}"]
}
