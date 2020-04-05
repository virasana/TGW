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

output "subnet_id_private" {
  value = aws_subnet.private.id
}

output "subnet_id_public" {
  value = aws_subnet.public.id
}

output "subnet_id_tgw" {
  value = aws_subnet.tgw.id
}

resource "aws_subnet" "private" {
  cidr_block = "10.${var.id}.0.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  tags = {
    name = "private_${var.id}"
    environment = var.environment
  }
}

resource "aws_subnet" "public" {
  cidr_block = "10.${var.id}.1.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  tags = {
    name = "public_${var.id}"
    environment = var.environment
  }
}

resource "aws_subnet" "tgw" {
  cidr_block = "10.${var.id}.2.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  tags = {
    name = "public_${var.id}"
    environment = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "public_${var.id}"
    environment = var.environment
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


}

resource "aws_route_table_association" "route_table_association_public" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id = aws_subnet.public.id
}