# modules/autoscaling/main.tf
/*
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  //tags = merge(var.tags, { Name = format("%s-vpc", var.env,)} )
}
resource "aws_instance" "foo" {
  ami           = "ami-0d95c7ccb8286fada" # us-west-2
  instance_type = "t2.micro"
}
resource "aws_security_group" "my-sg" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.this.id
}
resource "aws_iam_instance_profile" "iam" {
  name = "test_profile"
  //role = aws_iam_role.role.name
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCJRMNZ+KcY//0/6+lSvdM9I9UHh6rt9pkvwmv+Pv42m/r4tGp+sTaCOHpEN0QlUsZzugrTI6qjlL9P9f30C5eD3Lv6Omm6uNYznHFSJQoyR6MWoR3OB3kbTkcDMIQ6pEHhbeQlyGpbZlrKM473YKkyz7l6BE786c1k5USjy+lArJOcvmRT1Xwh+8A7zgUcrZsc6vhP1xK7FnHoK4cpYJ9mnC52+qBcxhppRqpZMzZaqivARC0TP7Indre8LBtjl/XDTU5bjL9WvpTvDsPLAebd3QDGLxwICWknLF6Xw1qaYt8VXqmKT1Ugt5tCdT45J9U9pSHlLdZugGeU01EUFfc6zeh7SZ4gFjRB/OoaCq7tUembV3+xaLmP/haecustYUJDjIDrHueavdr8Lx1olozflbRCeIe1VXSsa+JV4KI5WaXs7YOrkJlmYbIBDs1XSXfMvCkihsfIeMAJ5CsfW/GncYXa07zF81mrSnYqTtR71MF2pRKwcuS8xxorWLDed7U= sanskruti@DESKTOP-VP6KVO9"
}
# Define the launch configuration
resource "aws_launch_configuration" "alc" {
  depends_on = [aws_security_group.my-sg, aws_iam_instance_profile.iam, aws_key_pair.deployer]
  name_prefix      = "prefix"
  image_id          = var.ami_id
  instance_type    = var.instance_type
  security_groups  = var.security_groups
  // user_data        = var.user_data
}

resource "aws_autoscaling_policy" "asp" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
# Create the Auto Scaling group
resource "aws_autoscaling_group" "asg" {
  name                 = var.name
  launch_configuration = aws_launch_configuration.alc.id
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.subnets

  # Define scaling policies
  /*scaling_policy {
    name           = "scale-up"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 1
    cooldown       = var.scale_up_cooldown
  }

  scaling_policy {
    name           = "scale-down"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown       = var.scale_down_cooldown
  }*/

  # Define CloudWatch alarms
  /*metric {
    namespace  = "AWS/EC2"
    name       = "CPUUtilization"
    statistic  = "Average"
    period     = "60"
    threshold  = var.cpu_utilization_threshold
    comparison_operator = "GreaterThanOrEqualToThreshold"
  }*/


# Create a CloudWatch alarm for scaling up
/*resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "${var.name}-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  //metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  //threshold           = var.cpu_utilization_threshold
  alarm_actions       = [aws_autoscaling_policy.asp.arn]
}*/

# Create a CloudWatch alarm for scaling down
/*resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "${var.name}-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  //metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  //threshold           = var.cpu_utilization_threshold
  alarm_actions       = [aws_autoscaling_policy.asp.arn]
}*/