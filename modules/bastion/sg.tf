resource "aws_security_group" "ec2" {
  vpc_id = var.vpc_id != "" ? var.vpc_id : aws_vpc.this[0].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_name}-bastion-ec2"
  }
}