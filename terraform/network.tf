module "vpc_1" {
  source = "./modules/vpc"
  environment = "ks_one"
  id = 1
}

module "vpc_2" {
  source = "./modules/vpc"
  environment = "ks_two"
  id = 2
}

module "vpc_3" {
  source = "./modules/vpc"
  environment = "ks_three"
  id = 3
}

resource "aws_subnet" "public11" {
  cidr_block = "10.1.5.0/28"
  vpc_id = module.vpc_1.vpc_id
  availability_zone = "eu-west-2c"
  tags = {
    name = "public_11"
    environment = var.environment
  }
}