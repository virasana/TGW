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

resource "aws_subnet" "public1_alternate_zone" {
  cidr_block = "10.1.5.0/28"
  vpc_id = module.vpc_1.vpc_id
  availability_zone = "eu-west-2b"
  tags = {
    name = "public_alternate_zone"
    environment = var.environment
  }
}