module "vpc_1" {
  source = "./modules/vpc"
  environment = "ks_one"
  id = 1
  availability_zone = "eu-west-2a"
}

module "vpc_2" {
  source = "./modules/vpc"
  environment = "ks_two"
  id = 2
  availability_zone = "eu-west-2a"
}

module "vpc_3" {
  source = "./modules/vpc"
  environment = "ks_three"
  id = 3
  availability_zone = "eu-west-2a"
}

resource "aws_vpc" "vpc_4" {
  cidr_block = "10.4.0.0/16"
  tags = {
    name = "vpc_4"
    environment = var.environment
  }
}

resource "aws_subnet" "public1_alternate_zone" {
  cidr_block = "10.4.5.0/28"
  vpc_id = aws_vpc.vpc_4.id
  availability_zone = "eu-west-2b"
  tags = {
    name = "public_alternate_zone"
    environment = var.environment
  }
}

resource "aws_ec2_transit_gateway" "tgw" {
  tags = {
    name = "ks_tgw"
    environment = "network"
  }
  dns_support = "enable"
  vpn_ecmp_support = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_4_alternate_zone" {
  dns_support = "enable"
  vpc_id = aws_vpc.vpc_4.id
  subnet_ids = [aws_subnet.public1_alternate_zone.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_1_alternate_zone"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1" {
  dns_support = "enable"
  vpc_id = module.vpc_1.vpc_id
  subnet_ids = [module.vpc_1.subnet_id_private]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_1"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2" {
  dns_support = "enable"
  vpc_id = module.vpc_2.vpc_id
  subnet_ids = [module.vpc_2.subnet_id_private]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_2"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_3" {
  dns_support = "enable"
  vpc_id = module.vpc_3.vpc_id
  subnet_ids = [module.vpc_3.subnet_id_private]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_3"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rt1" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

# TODO
//resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_1" {
//  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
//  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt1.id
//}