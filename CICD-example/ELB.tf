resource "aws_elb" "ELB" {
  name               = "user19-ELB"
  internal           = false
  security_groups    = ["${aws_security_group.SecurityGroup.id}"]
  subnets            = ["${aws_subnet.publicSubnet01.id}",
                        "${aws_subnet.publicSubnet02.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = {
    Name = "user19-ELB"
  }
}

resource "aws_launch_configuration" "LaunchConfiguration" {
  image_id                    = "ami-0ec0b3eb271f5afbc"       #ami-05655c267c89566dd         ami-0ec0b3eb271f5afbc
  instance_type               = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.InstanceProfile.id}" 
  key_name                    = var.default_keypair_name
  security_groups             = [
    "${aws_default_security_group.DefaultSecurityGroup.id}",
    "${aws_security_group.SecurityGroup.id}"
  ]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum upgrade
yum install -y aws-cli
yum install -y git
cd /home/ec2-user/
wget https://aws-codedeploy-us-west-1.s3.amazonaws.com/latest/codedeploy-agent.noarch.rpm
yum -y install codedeploy-agent.noarch.rpm
service codedeploy-agent start
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "AutoscalingGroup" {
  name                      = "user19-AutoscalingGroup"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1

  load_balancers            = ["${aws_elb.ELB.name}"]
  health_check_type         = "ELB"
  launch_configuration      = "${aws_launch_configuration.LaunchConfiguration.name}"
  vpc_zone_identifier       = ["${aws_subnet.publicSubnet01.id}", "${aws_subnet.publicSubnet02.id}"]
  
  enabled_metrics           = [
     "GroupDesiredCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupTotalInstances"
     ]
  
  metrics_granularity       = "1Minute"

  tag {
    key                 = "Name"
    value               = "user19-DevWebApp01"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "PolicyDown" {
  name                   = "user19-PolicyDown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = "${aws_autoscaling_group.AutoscalingGroup.name}"
}

resource "aws_autoscaling_policy" "PolicyUp" {
  name                   = "user19-PolicyUp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = "${aws_autoscaling_group.AutoscalingGroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "CpuDownAlarm" {
  alarm_name                = "user19-CpuDownAlarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "10"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = ["${aws_autoscaling_policy.PolicyDown.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CpuUpAlarm" {
  alarm_name                = "user19-CpuUpAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = ["${aws_autoscaling_policy.PolicyUp.arn}"]
}
