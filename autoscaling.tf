
resource "aws_launch_configuration" "autoscaleapp-launchconfig" {
    name_prefix = "autoscaleapplaunchconfig"
    image_id = var.AMI
    instance_type = "t2.micro"
    key_name = aws_key_pair.mykeypair.key_name
    security_groups = [aws_security_group.allow-ssh.id]
    user_data       = file("install_docker.sh")
    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_autoscaling_group" "autoscaleapp-autoscalinggroup" {
  name = "autoscaleapp-autoscalinggroup"
  vpc_zone_identifier = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration = aws_launch_configuration.autoscaleapp-launchconfig.name
  min_size = 2
  max_size = 3
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  load_balancers = [aws_elb.autoscaleapp-elb.name]
  tag {
      key = "Name"
      value = "ec2 Instance"
      propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "autoscaleapp-cpuup-policy" {
    name = "autoscaleapp-cpuup-policy"
    autoscaling_group_name = aws_autoscaling_group.autoscaleapp-autoscalinggroup.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "autoscaleapp-cpudown-policy" {
    name = "autoscaleapp-cpudown-policy"
    autoscaling_group_name = aws_autoscaling_group.autoscaleapp-autoscalinggroup.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "-1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "autoscaleapp-cpuhigh-alarm" {
  alarm_name          = "autoscaleapp-cpuhigh-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaleapp-autoscalinggroup.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.autoscaleapp-cpuup-policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "autoscaleapp-cpulow-alarm" {
  alarm_name          = "autoscaleapp-cpulow-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaleapp-autoscalinggroup.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization if it goes below a certain threshold"
  alarm_actions     = [aws_autoscaling_policy.autoscaleapp-cpudown-policy.arn]
}


