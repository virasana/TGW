module "vpc_1" {
  source = "./modules/vpc"
  environment = "ks_one"
  id = 1
  availability_zone = "eu-west-1a"
}

module "vpc_2" {
  source = "./modules/vpc"
  environment = "ks_two"
  id = 2
  availability_zone = "eu-west-1a"
}

module "vpc_3" {
  source = "./modules/vpc"
  environment = "ks_three"
  id = 3
  availability_zone = "eu-west-1a"
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

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1" {
  dns_support = "enable"
  vpc_id = module.vpc_1.vpc_id
  subnet_ids = [module.vpc_1.subnet_id_tgw]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_1"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2" {
  dns_support = "enable"
  vpc_id = module.vpc_2.vpc_id
  subnet_ids = [module.vpc_2.subnet_id_tgw]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_2"
  }
  depends_on = [module.vpc_1, module.vpc_2]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_3" {
  dns_support = "enable"
  vpc_id = module.vpc_3.vpc_id
  subnet_ids = [module.vpc_3.subnet_id_tgw]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    name = "vpc_3"
  }
  depends_on = [module.vpc_1, module.vpc_2]
}

resource "aws_ec2_transit_gateway_route_table" "rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_3" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt.id
}