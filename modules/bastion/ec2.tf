data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.8.20250818.0-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "this" {
  ami                     = data.aws_ami.this.id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id != "" ? var.subnet_id : aws_subnet.public[0].id
  availability_zone       = var.availability_zone != "" ? var.availability_zone : null
  iam_instance_profile    = aws_iam_instance_profile.session_manager.name
  vpc_security_group_ids  = [aws_security_group.ec2.id]
  disable_api_termination = var.disable_api_termination

  user_data = file("${path.module}/script/userdata.sh")

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name = var.resource_name
  }

  root_block_device {
    volume_size           = 30
    delete_on_termination = true
    tags = {
      Name = "${var.resource_name}-ebs"
    }
  }
}

resource "aws_eip" "this" {
  count    = var.assign_eip ? 1 : 0
  instance = aws_instance.this.id
  tags = {
    Name = "${var.resource_name}-eip"
  }
}