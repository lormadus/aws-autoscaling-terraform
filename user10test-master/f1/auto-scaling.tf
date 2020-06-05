resource "aws_autoscaling_group" "user10_r1_autoscale_group_web" {
  name = "user10-${aws_launch_configuration.user10_r1_web_launch_config.name}-auto-scaling-group"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 3

  health_check_type    = "ELB"
  load_balancers= [
    "${aws_elb.user10_r1_web_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.user10_r1_web_launch_config.name}"
  ####  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]  아래 vpc_zone_identifier 와 중복

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity="1Minute"

  vpc_zone_identifier  = [
    "${aws_subnet.user10_r1_sub1.id}",
    "${aws_subnet.user10_r1_sub2.id}"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "user10_r1_autoscale_group_web"
    propagate_at_launch = true
  }
}
#8080 오토스케일링 정책
resource "aws_autoscaling_group" "user10_r1_autoscale_group_web8080" {
  name = "user10-${aws_launch_configuration.user10_r1_web8080_launch_config.name}-auto-scaling-group"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 3

  health_check_type    = "ELB"
  load_balancers= [
    "${aws_elb.user10_r1_web8080_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.user10_r1_web8080_launch_config.name}"
  ####  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]  아래 vpc_zone_identifier 와 중복

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity="1Minute"

  vpc_zone_identifier  = [
    "${aws_subnet.user10_r1_sub1.id}",
    "${aws_subnet.user10_r1_sub2.id}"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "user10_r1_autoscale_group_web8080"
    propagate_at_launch = true
  }
}