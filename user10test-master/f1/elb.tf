# ELB r1의 subent1 / subnet2의 로드밸런서
# ELB에는 ALB의 로그남기는 방식을 적용하면 오류 발생
# ELB는 ALB처럼 log남기는 것을 안해도 생성이 된다.
resource "aws_elb" "user10_r1_web_elb" {
  name = "user10-r1-web-elb"
  security_groups = [aws_security_group.user10_r1_elb_sg.id]
  subnets = [aws_subnet.user10_r1_sub1.id, aws_subnet.user10_r1_sub2.id]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}
# ELB r1의 8080포트 subent1 / subnet2의 로드밸런서
resource "aws_elb" "user10_r1_web8080_elb" {
  name = "user10-r1-web8080-elb"
  security_groups = [aws_security_group.user10_r1_elb8080_sg.id]
  subnets = [aws_subnet.user10_r1_sub1.id, aws_subnet.user10_r1_sub2.id]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/" #8080port Health Check
  }
  #8080포트 로드밸런싱
  listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}

# ELB 시큐리티그룹
resource "aws_security_group" "user10_r1_elb_sg" {
    name = "user10-r1-elb-sg"
    description = "Allow HTTP traffic to instances through Elastic Load Balancer"
    vpc_id = aws_vpc.user10_r1_vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "user10_r1_elb_sg"
    }
}

# ELB8080 시큐리티그룹
resource "aws_security_group" "user10_r1_elb8080_sg" {
    name = "user10-r1-elb8080-sg"
    description = "Allow HTTP traffic to instances through Elastic Load Balancer"
    vpc_id = aws_vpc.user10_r1_vpc.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "user10_r1_elb8080_sg"
    }
}

## 타겟 VPC 설정
#resource "aws_alb_target_group" "user10-r1-elb-target" {
#    name = "user10-r1-elb-target"
#    port = 80
#    protocol = "HTTP"
#    vpc_id = aws_vpc.user10_r1_vpc.id
#    health_check {
#        interval = 30
#        path = "/ping"
#        healthy_threshold = 3
#        unhealthy_threshold = 3
#    }
#    tags = { Name = "user10-r1-elb-target" }
#}
## 타겟 그룹에 서브넷 대상 추가
#resource "aws_alb_target_group_attachment" "user10_r1_ins1_2a" {
#    target_group_arn = aws_alb_target_group.user10-r1-elb-target.arn
#    target_id = aws_instance.user10_r1_ins1.id
#    port = 80
#}
#resource "aws_alb_target_group_attachment" "user10_r1_ins1_2b" {
#    target_group_arn = aws_alb_target_group.user10-r1-elb-target.arn
#    target_id = aws_instance.user10_r1_ins2.id
#    port = 80
#}