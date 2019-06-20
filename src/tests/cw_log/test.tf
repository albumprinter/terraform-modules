provider "aws" {
  region = "eu-west-1"
}

locals {
  log_name = "test-cw-log"
}

module "label" {
  source      = "../../modules/resources/label"
  application = "test-app"
  name        = "app"
  environment = "test"
  domain      = "ci-cd platform"
  cost_center = "3600"
  team        = "customer care technology"
}

module log_group {
  source = "../../modules/resources/cw/log_group"
  name   = "${local.log_name}"
  tags   = "${module.label.tags}"
}

module filter {
  source         = "../../modules/resources/cw/metric_filter"
  name           = "${local.log_name}-filter"
  log_group_name = "${local.log_name}"
  pattern        = "Error"
}

module "alarm" {
  source              = "../../modules/resources/cw/metric_alarm"
  name                = "${local.log_name}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "1"
  metric_name         = "${local.log_name}-metric"
  statistic           = "SampleCount"
  period              = "3600"
}

output "cw-log-arn" {
  value = "${module.log_group.arn}"
}

output "cw-metric-arn" {
  value = "${module.filter.name}"
}

output "cw-alarm-arn" {
  value = "${module.alarm.arn}"
}
