#Provisioning Infrastructure for Project Expansion

resource "aws_vpc" "Jenkins-VPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Jenkins-VPC"
  }
}

resource "aws_subnet" "Pub-Sub1" {
  vpc_id     = aws_vpc.Jenkins-VPC.id
  cidr_block = var.Pub_Sub1_cidr

  tags = {
    Name = "Pub-Sub1"
  }
}

resource "aws_subnet" "Pub-Sub2" {
  vpc_id     = aws_vpc.Jenkins-VPC.id
  cidr_block = var.Pub_Sub2_cidr

  tags = {
    Name = "Pub-Sub2"
  }
}

resource "aws_subnet" "Priv-Sub1" {
  vpc_id     = aws_vpc.Jenkins-VPC.id
  cidr_block = var.Priv_Sub1_cidr

  tags = {
    Name = "Priv-Sub1"
  }
}

resource "aws_subnet" "Priv-Sub2" {
  vpc_id     = aws_vpc.Jenkins-VPC.id
  cidr_block = var.Priv_Sub2_cidr

  tags = {
    Name = "Priv-Sub2"
  }
}

resource "aws_route_table" "Pub-RT" {
  vpc_id = aws_vpc.Jenkins-VPC.id

tags = {
    Name = "Pub-RT"
  }
}

resource "aws_route_table" "Priv-RT" {
  vpc_id = aws_vpc.Jenkins-VPC.id

tags = {
    Name = "Priv-RT"
  }
}

resource "aws_route_table_association" "Pub-RTA1" {
  subnet_id      = aws_subnet.Pub-Sub1.id
  route_table_id = aws_route_table.Pub-RT.id
}

resource "aws_route_table_association" "Pub-RTA2" {
  subnet_id      = aws_subnet.Pub-Sub2.id
  route_table_id = aws_route_table.Pub-RT.id
}

resource "aws_route_table_association" "Priv-RTA1" {
  subnet_id      = aws_subnet.Priv-Sub1.id
  route_table_id = aws_route_table.Priv-RT.id
}

resource "aws_route_table_association" "Priv-RTA2" {
  subnet_id      = aws_subnet.Priv-Sub2.id
  route_table_id = aws_route_table.Priv-RT.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Jenkins-VPC.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route" "Public-route" {
  route_table_id            = aws_route_table.Pub-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
  
  tags = {
    Name = "eip"
}
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Priv-Sub1.id

  tags = {
    Name = "ngw"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "Private-route" {
  route_table_id            = aws_route_table.Priv-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw.id
}  