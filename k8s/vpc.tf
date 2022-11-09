#vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

#subnet
resource "aws_subnet" "pub10" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "k8s-public-2a-10"
  }
}

resource "aws_subnet" "pub20" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.20.0/24"
  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "k8s-public-2c-20"
  }
}

resource "aws_subnet" "pri11" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "k8s-private-2a-11"
  }
}

resource "aws_subnet" "pri21" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.21.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "k8s-private-2c-21"
  }
}

resource "aws_subnet" "pri12" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.12.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "k8s-private-2a-12"
  }
}

resource "aws_subnet" "pri22" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.22.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "k8s-private-2c-22"
  }
}

resource "aws_subnet" "pri13" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.13.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "k8s-private-2a-13"
  }
}

resource "aws_subnet" "pri23" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.23.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "k8s-private-2c-23"
  }
}

#IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "k8s-igw"
  }
}

#NAT
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub10.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#RTB
resource "aws_route_table" "rtb_pub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "k8s-rtb-public"
  }
}

resource "aws_route_table" "rtb_private_11" {
  vpc_id = aws_vpc.vpc.id
  
    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "k8s-rtb-private-11-a"
  }
}

resource "aws_route_table" "rtb_private_21" {
  vpc_id = aws_vpc.vpc.id

		route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

  tags = {
    Name = "k8s-rtb-private-21-c"
  }
}

resource "aws_route_table" "rtb_private_12" {
  vpc_id = aws_vpc.vpc.id

		route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

  tags = {
    Name = "k8s-rtb-private-12-c"
  }
}

resource "aws_route_table" "rtb_private_22" {
  vpc_id = aws_vpc.vpc.id

		route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

  tags = {
    Name = "k8s-rtb-private-22-c"
  }
}

resource "aws_route_table" "rtb_private_13" {
  vpc_id = aws_vpc.vpc.id

		route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

  tags = {
    Name = "k8s-rtb-private-13-c"
  }
}

resource "aws_route_table" "rtb_private_23" {
  vpc_id = aws_vpc.vpc.id

		route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

  tags = {
    Name = "k8s-rtb-private-23-c"
  }
}

resource "aws_route_table_association" "public10" {
  subnet_id      = aws_subnet.pub10.id
  route_table_id = aws_route_table.rtb_pub.id
}

resource "aws_route_table_association" "public20" {
  subnet_id      = aws_subnet.pub20.id
  route_table_id = aws_route_table.rtb_pub.id
}

resource "aws_route_table_association" "private11" {
  subnet_id      = aws_subnet.pri11.id
  route_table_id = aws_route_table.rtb_private_11.id
}

resource "aws_route_table_association" "private21" {
  subnet_id      = aws_subnet.pri21.id
  route_table_id = aws_route_table.rtb_private_21.id
}

resource "aws_route_table_association" "private12" {
  subnet_id      = aws_subnet.pri12.id
  route_table_id = aws_route_table.rtb_private_12.id
}

resource "aws_route_table_association" "private22" {
  subnet_id      = aws_subnet.pri22.id
  route_table_id = aws_route_table.rtb_private_22.id
}

resource "aws_route_table_association" "private13" {
  subnet_id      = aws_subnet.pri13.id
  route_table_id = aws_route_table.rtb_private_13.id
}

resource "aws_route_table_association" "private23" {
  subnet_id      = aws_subnet.pri23.id
  route_table_id = aws_route_table.rtb_private_23.id
}