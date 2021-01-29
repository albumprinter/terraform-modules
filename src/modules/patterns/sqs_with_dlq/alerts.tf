resource "aws_cloudwatch_metric_alarm" "event_queue_alarm_1" {
  alarm_name          = "${var.name} age of oldest message >= 8 hour(s)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300" // 5 minutes
  statistic           = "Maximum"
  threshold           = "28800" // 8 hours
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.queue.name}"
  }
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "event_queue_alarm_2" {
  alarm_name          = "${var.name} age of oldest message >= 24 hour(s)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "3600" // 1 hour
  statistic           = "Maximum"
  threshold           = "86400" // 24 hours
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.queue.name}"
  }
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "event_queue_alarm_3" {
  alarm_name          = "${var.name} age of oldest message >= 72 hour(s)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "21600" // 6 hours
  statistic           = "Maximum"
  threshold           = "259200" // 72 hours
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.queue.name}"
  }
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "event_dlq_alarm_1" {
  alarm_name          = "${module.dlq.name} number of message(s) visible >= 1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60" // 1 minute
  statistic           = "Average"
  threshold           = "0"
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.dlq.name}"
  }
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "event_dlq_alarm_2" {
  alarm_name          = "${module.dlq.name} age of oldest message >= 24 hour(s)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "3600" // 1 hour
  statistic           = "Maximum"
  threshold           = "86400" // 24 hours
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.dlq.name}"
  }
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "event_dlq_alarm_3" {
  alarm_name          = "${module.dlq.name} age of oldest message >= 72 hour(s)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "21600" // 6 hours
  statistic           = "Maximum"
  threshold           = "259200" // 72 hours
  treat_missing_data  = "notBreaching"
  datapoints_to_alarm = "1"
  alarm_actions       = ["${var.alarm_action_arn}"]
  count               = "${var.enable_cloudwatch_alarms}"
  dimensions = {
    QueueName = "${module.dlq.name}"
  }
  tags = var.tags
}