resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size             = 2
  desired_capacity     = 2
  max_size             = 3

  health_check_type    = "ELB"
  #load_balancers= ["${aws_alb.alb.id}" ] #classic
  target_group_arns   = [aws_alb_target_group.frontend.arn]
  #alb = "${aws_alb.alb.id}"
  
  launch_configuration = aws_launch_configuration.web.name
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity="1Minute"

  vpc_zone_identifier  = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "user06-web-autoscaling"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "user01-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_alb_target_group.frontend.arn
}


