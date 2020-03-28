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
  instance_type = var.instance_type
  associate_public_ip_address = "true"
  key_name = var.ssh_key_name
  tags = {
    name = "public_1"
    environment = var.environment
  }

  security_groups = [aws_security_group.ingress-all-1.id]

  availability_zone = var.availability_zone
  subnet_id = module.vpc_1.subnet_id_public
}

resource "aws_instance" "public_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = "true"
  key_name = var.ssh_key_name

  tags = {
    name = "public_2"
    environment = var.environment
  }

  security_groups = [aws_security_group.ingress-all-2.id]

  availability_zone = var.availability_zone
  subnet_id = module.vpc_2.subnet_id_public
}

resource "aws_key_pair" "ec2" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe5rolPThs7BB9Us7zmdPqkJHhkeMt4k8SW16HCxdgi5hKhHCJxZBeCS7Ao+Wvymt7Mj1JrEhS0yxGl3UM/gjQfeWzPc3iWmiirX+n/Wqo0MKW1XAaT9yrzlYf8ZVESNLblfpEezZUH2DA6Mu7fSDt+Otvi8bPUyTb0jGNiAH5vYcauVWpe2JjYQ+JqpuSQf1o7PYcf+gg+69jTBu91RVAw08VtOBat7sLRXPQwKFaKkHA4OL7dEraRx5Qh8ZirrAi8TtjPnAHG4X6/2X371j4CJD6GjO4X7jdEihtrZRv5XFn9wcZwH0B41fr7pSmKW+S3YzOppgFvf/Yl8qAp/Y9 jean-pierre@LAPPIE2"
  key_name = "ksone"
}

resource "aws_security_group" "ingress-all-1" {
  name = "allow-all-sg"
  vpc_id = module.vpc_1.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-2" {
  name = "allow-all-sg"
  vpc_id = module.vpc_2.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ingress-all-3" {
  name = "allow-all-sg"
  vpc_id = module.vpc_3.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-4" {
  name = "allow-all-sg"
  vpc_id = aws_vpc.vpc_4.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}