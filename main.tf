terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "run-command-failed"
  alarm_description   = "Run Command has failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  period              = 300
  unit                = "Count"

  namespace   = "AWS/SSM-RunCommand"
  metric_name = "CommandsFailed"
  statistic   = "Sum"

  alarm_actions = [aws_sns_topic.run_command_errors.arn]
}

resource "aws_sns_topic" "run_command_errors" {
  name_prefix = "run-command-errors-"
}

resource "aws_sns_topic_subscription" "run_command_errors_target" {
  topic_arn = aws_sns_topic.run_command_errors.arn
  protocol  = "email"
  endpoint  = var.email_to_notify
}