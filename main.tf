locals {
  profile = "fl-dev"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  #profile = "default"
  profile = local.profile
  region  = "us-east-2"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "logs"
  retention_in_days = 1

  tags = {
    Application = "test-service"
  }
}

resource "aws_cloudwatch_log_stream" "stream" {
  name           = "stream"
  log_group_name = aws_cloudwatch_log_group.logs.name
}

resource "aws_cloudwatch_log_metric_filter" "metric" {
  name           = "my-metric-filter"
  pattern        = "[dep = DEP, get = GET, status, time]"
  log_group_name = aws_cloudwatch_log_group.logs.name

  metric_transformation {
    name      = "metric-exec-time"
    namespace = "metric-namespace"
    value     = "$time"
    unit      = "Milliseconds"
    dimensions = {
      status = "$status"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "too-slow-200" {
  alarm_name                = "too-slow-200"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "metric-exec-time"
  namespace                 = "metric-namespace"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "800"
  alarm_description         = "200 are too slow"
  dimensions = {
    status = "200"
  }
}
