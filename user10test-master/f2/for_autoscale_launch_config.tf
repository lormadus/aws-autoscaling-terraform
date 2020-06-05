resource "aws_launch_configuration" "user10_r2_web_launch_config" {
    name_prefix = "user10-r2-web-launch-config"
    image_id = var.amazon_linux #eu-west-2 Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    key_name = var.keyName # var에서 keyName에 AWS에 등록될 키페어 명칭 수정

    security_groups = [aws_security_group.user10_r2_sg.id]
    associate_public_ip_address = true
#아래 스크립트를 인스턴스 생성 후 실행
    user_data = <<USER_DATA
#!/bin/bash
yum update -y
yum install httpd -y
cd /var/www/html/
echo "<html> Hello <img src=\"http://d1tjwiim536ydg.cloudfront.net/user10.jpg\"> </html>" > index.html
systemctl start httpd.service
systemctl status httpd.service
    USER_DATA

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_launch_configuration" "user10_r2_web8080_launch_config" {
    name_prefix = "user10-r2-web8080-launch-config"
    image_id = var.amazon_linux #eu-west-2 Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    key_name = var.keyName # var에서 keyName에 AWS에 등록될 키페어 명칭 수정

    security_groups = [aws_security_group.user10_r2_sg.id]
    associate_public_ip_address = true
#아래 스크립트를 인스턴스 생성 후 실행
    user_data = <<USER_DATA
#!/bin/bash
yum update -y
yum install httpd -y
cd /var/www/html/
echo "<html> Hello <img src=\"http://d1tjwiim536ydg.cloudfront.net/djsura10.jpg\"> </html>" > index.html
systemctl start httpd.service
systemctl status httpd.service
    USER_DATA

    lifecycle {
        create_before_destroy = true
    }
}
#    user_data = <<USER_DATA
##!/bin/bash
#yum update
#yum -y install nginx
#echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" > /usr/share/nginx/html/index.html
#chkconfig nginx on
#service nginx start
#    USER_DATA
#
#    lifecycle {
#        create_before_destroy = true
#    }
