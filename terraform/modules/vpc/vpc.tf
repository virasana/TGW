resource "aws_vpc" "vpc" {
  cidr_block = "10.${var.id}.0.0/16"
  tags = {
    name = "vpc_${var.id}"
    environment = var.environment
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

resource "aws_subnet" "private" {
  cidr_block = "10.${var.id}.1.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  tags = {
    name = "private_${var.id}"
    environment = var.environment
  }
}

resource "aws_subnet" "public" {
  cidr_block = "10.${var.id}.0.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  tags = {
    name = "public_${var.id}"
    environment = var.environment
  }
}