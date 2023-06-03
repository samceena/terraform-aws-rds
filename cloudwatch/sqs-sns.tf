variable "queue_name" {
  type    = string
  default = "queue-name"
}
variable "metric_name_var" {
  type    = string
  default = "ApproximateAgeOfOldestMessage"
}


resource "aws_cloudwatch_metric_alarm" "sqs_sns_alram" {
  alarm_name          = "${var.metric_name_var} issue in ${var.queue_name} queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1 # Additional configuration: Datapoints to alarm
  metric_name         = var.metric_name_var
  period              = 900 # check every 300 seconds or 5 mins
  threshold           = 3600
  statistic           = "Average"
  namespace           = "AWS/SQS"

  actions_enabled = "true"
  alarm_actions   = [aws_sns_topic.Default_CloudWatch_Alarms_Topic.arn] # this topic must be existing

  dimensions = {
    QueueName = var.queue_name
  }

  alarm_description = "There's an issue with the ${var.metric_name_var} metric in the ${var.queue_name} queue. Please check."
}

resource "aws_sns_topic" "Default_CloudWatch_Alarms_Topic" {
  name         = "Default_CloudWatch_Alarms_Topic"
  display_name = "Default_CloudWatch_Alarms_Topic"
}
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.Default_CloudWatch_Alarms_Topic.arn
  protocol  = "email"
  endpoint  = "" # email address
}
resource "aws_sns_topic_subscription" "pagerduty_alert" {
  topic_arn = aws_sns_topic.Default_CloudWatch_Alarms_Topic.arn
  protocol  = "https"
  endpoint  = "" # url to pager duty event queue
}
