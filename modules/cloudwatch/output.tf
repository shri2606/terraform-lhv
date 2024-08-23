output "cloudwatch_log_groups" {
  description = "CloudWatch log group names"
  value       = aws_cloudwatch_log_group.ec2_logs[*].name
}

output "cloudwatch_alarms" {
  description = "CloudWatch alarm names"
  value       = aws_cloudwatch_metric_alarm.high_cpu[*].alarm_name
}
