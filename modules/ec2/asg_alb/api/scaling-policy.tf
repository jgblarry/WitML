################
## Scaling Up ##
################

resource "aws_autoscaling_policy" "up" {
  name                   = "${var.application}-${var.env}-Scaling-Up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.AutoSG.name
}

resource "aws_cloudwatch_metric_alarm" "up" {
  alarm_name          = "${var.application}-${var.env}-Scaling-Up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = "120"
  statistic           = var.statistic
  threshold           = var.threshold_up

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.AutoSG.name}"
  }

  alarm_description = "[${var.project}-${aws_autoscaling_group.AutoSG.name}-ScalinUp]"
  alarm_actions     = ["${aws_autoscaling_policy.up.arn}"]
}



##################
## Scaling Down ##
##################

resource "aws_autoscaling_policy" "down" {
  name                   = "${var.application}-${var.env}-Scaling-Down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.AutoSG.name
}

resource "aws_cloudwatch_metric_alarm" "down" {
  alarm_name          = "${var.application}-${var.env}-Scaling-Down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = "120"
  statistic           = var.statistic
  threshold           = var.threshold_down

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.AutoSG.name}"
  }

  alarm_description = "[${var.project}-${aws_autoscaling_group.AutoSG.name}-ScalinDown]"
  alarm_actions     = ["${aws_autoscaling_policy.down.arn}"]
}