data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"

    values = ["al2023-ami-*-kernel-6.1-x86_64"] # x86_64
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.session_manager.name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = file("${path.module}/policy/userdata.sh")

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name = var.resouce_name
  }
}