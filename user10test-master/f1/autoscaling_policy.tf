resource "aws_autoscaling_policy" "user10_r1_autoscale_group_web_policy_up" {
  name = "user10_r1_autoscale_group_web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 10
  autoscaling_group_name = "${aws_autoscaling_group.user10_r1_autoscale_group_web.name}"
}

resource "aws_cloudwatch_metric_alarm" "user10_r1_autoscale_group_web_cpu_alarm_up" {
  alarm_name = "user10_r1_autoscale_group_web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  #dimensions {
  #  AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  #}

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.user10_r1_autoscale_group_web_policy_up.arn}"]
}
# 8080 오토스케일링 확장정책
resource "aws_autoscaling_policy" "user10_r1_autoscale_group_web8080_policy_up" {
  name = "user10_r1_autoscale_group_web8080_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 10
  autoscaling_group_name = "${aws_autoscaling_group.user10_r1_autoscale_group_web8080.name}"
}
# 8080 오토스케일링 확장정책
resource "aws_cloudwatch_metric_alarm" "user10_r1_autoscale_group_web8080_cpu_alarm_up" {
  alarm_name = "user10_r1_autoscale_group_web8080_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  #dimensions {
  #  AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  #}

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.user10_r1_autoscale_group_web8080_policy_up.arn}"]
}