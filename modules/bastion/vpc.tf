resource "aws_vpc" "this" {
  count = var.vpc_id == "" ? 1 : 0

  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.resource_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.subnet_id == "" ? 1 : 0

  vpc_id            = var.vpc_id != "" ? var.vpc_id : (length(aws_vpc.this) > 0 ? aws_vpc.this[0].id : null)
  availability_zone = var.availability_zone != "" ? var.availability_zone : null
  cidr_block        = var.subnet_cidr

  tags = {
    Name = "${var.resource_name}-public-subnet"
  }
}