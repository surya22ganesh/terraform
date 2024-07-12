provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_sns_topic" "my_sns_topic" {
  name = "my-sns-topic"
  display_name = "surya_topic"
}

resource "aws_sns_topic_subscription" "my_sns_topic_subs" {
   topic_arn = aws_sns_topic.my_sns_topic.arn
   protocol  = "email"
   endpoint = "sample-email@gmail.com"  
   endpoint_auto_confirms = true
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_util_alarm" {
  alarm_name                = "terraform-cpu-util-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"   #LessThanThreshold
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 0.2      
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  actions_enabled = true
 
  
  dimensions = {
    InstanceId = "i-08e8e27a3109c8a2a"  #instance ID
  }
  
}
