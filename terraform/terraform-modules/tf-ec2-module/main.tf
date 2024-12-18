provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(local.common_tags, { Name = var.vpc_name })
}


resource "aws_internet_gateway" "net-igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "net-igw" })
}

resource "aws_instance" "web" {
  ami                    = "ami-02141377eee7defb9" # Ubuntu AMI
  instance_type          = "t2.micro"
  availability_zone      = var.public_subnet_az
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = merge(local.common_tags, { Name = "WebServer" })

  user_data = file("python_web_server.sh")
}

