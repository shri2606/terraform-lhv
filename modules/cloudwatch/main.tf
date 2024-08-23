resource "aws_cloudwatch_log_group" "ec2_logs" {
  count = length(var.ec2_instance_ids)

  name              = "/aws/ec2/${var.environment}-${count.index}-logs"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count                   = length(var.ec2_instance_ids)
  alarm_name              = "${var.environment}-high_cpu_utilization-${count.index}"
  comparison_operator     = "GreaterThanOrEqualToThreshold"
  evaluation_periods      = "2"
  metric_name             = "CPUUtilization"
  namespace               = "AWS/EC2"
  period                  = "300"
  statistic               = "Average"
  threshold               = "80"
  alarm_description       = "This metric monitors EC2 CPU utilization"
  actions_enabled         = true

  dimensions = {
    InstanceId = var.ec2_instance_ids[count.index]
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alert.arn]
}

resource "aws_sns_topic" "cloudwatch_alert" {
  name = "${var.environment}-cloudwatch-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_alert.arn
  protocol  = "email"
  endpoint  = "svs@gmail.com"
}
