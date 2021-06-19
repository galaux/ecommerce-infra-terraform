resource "aws_security_group" "main" {
  name        = var.name
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = local.open_ports_ipv4

    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # ie "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name
  # Watch-out: it seems the instance profile can only be associated with the
  # instance when the instance is created. ie: if you delete then re-create
  # the profile, it won't be associated with the instance. It seems the only
  # solution left is to re-provision the instance.
  # FYI, list the instance profile with:
  #   aws --profile=shop-test iam list-instance-profiles
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.name
  }
}

resource "aws_cloudwatch_metric_alarm" "stop_if_unused" {
  count = var.stop_if_unused ? 1 : 0

  alarm_name        = "${var.name}_stop_if_unused"
  alarm_description = "Stop the instance if IN network is under a threshold"
  # FIXME use aws_cloudwatch_event_target as shown here
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target
  # https://gist.github.com/picadoh/815c11361d1a88419ea16b14fe044e85
  alarm_actions = [
    "arn:aws:swf:eu-central-1:${var.aws_account_id}:action/actions/AWS_EC2.InstanceId.Stop/1.0"
  ]
  insufficient_data_actions = []
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  dimensions = {
    InstanceId = aws_instance.main.id
  }
  # Create one data point every 900s (15') and trigger alarm if 8 of these
  # points out of 8 have an average NetworkIn <= 5000.
  # 8 × 15' = 2h so this means the alarm will be triggered if every 15' for the
  # past 2h, the average NetworkIn has been under 5000.
  period              = "900"
  evaluation_periods  = "8"
  datapoints_to_alarm = "8"
  threshold           = "5000"
  comparison_operator = "LessThanThreshold"
}
