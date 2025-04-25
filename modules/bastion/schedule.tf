# Start
resource "aws_scheduler_schedule" "bastion_start" {
  name                         = "${var.resouce_name}-bastion-schedule-start"
  schedule_expression          = var.start_time
  schedule_expression_timezone = var.timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.ec2_schedule.arn

    input = jsonencode({
      InstanceIds = [aws_instance.this.id]
    })
  }
}

# Stop
resource "aws_scheduler_schedule" "bastion_stop" {
  name                         = "${var.resouce_name}-bastion-schedule-stop"
  schedule_expression          = var.stop_time
  schedule_expression_timezone = var.timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.ec2_schedule.arn

    input = jsonencode({
      InstanceIds = [aws_instance.this.id]
    })
  }
}