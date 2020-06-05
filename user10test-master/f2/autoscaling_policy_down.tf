resource "aws_autoscaling_policy" "user10_r2_autoscale_group_web_policy_down" {
  name = "user10_r2_autoscale_group_web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.user10_r2_autoscale_group_web.name}"
}

resource "aws_cloudwatch_metric_alarm" "user10_r2_autoscale_group_web_cpu_alarm_down" {
  alarm_name = "user10_r2_autoscale_group_web_web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  #dimensions {
  #  AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  #:}

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.user10_r2_autoscale_group_web_policy_down.arn}"]
}
#8080 오토스케일링 축소 정책
resource "aws_autoscaling_policy" "user10_r2_autoscale_group_web8080_policy_down" {
  name = "user10_r2_autoscale_group_web8080_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.user10_r2_autoscale_group_web8080.name}"
}
#8080 오토스케일링 축소 정책
resource "aws_cloudwatch_metric_alarm" "user10_r2_autoscale_group_web8080_cpu_alarm_down" {
  alarm_name = "user10_r2_autoscale_group_web_web8080_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  #dimensions {
  #  AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  #:}

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.user10_r2_autoscale_group_web8080_policy_down.arn}"]
}