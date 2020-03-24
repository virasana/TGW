data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "public_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    name = "public_1"
    environment = var.environment
  }

  availability_zone = var.availability_zone
  subnet_id = module.vpc_1.subnet_id_public
}

resource "aws_instance" "public_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    name = "public_2"
    environment = var.environment
  }

  availability_zone = var.availability_zone
  subnet_id = module.vpc_2.subnet_id_public
}