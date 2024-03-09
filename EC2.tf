resource "aws_instance" "Jenkins-EC2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.Pub-Sub1.id
  tags = {
    Name = "Jenkins-EC2"
 }
}

# Creating a key pair
resource "aws_key_pair" "Jenkins-KP2" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Saving the key pair in your local computer
resource "local_file" "Jenkins-KP2" {
  content = tls_private_key.rsa.private_key_pem
  filename = var.filename
}

# Creating security group
resource "aws_security_group" "SG" {
  name        = var.security_group_name
  description = "Security group using terraform"
  vpc_id      = aws_vpc.Jenkins-VPC.id

  tags = {
    Name = "SG"
  }
}

# Inbound rules
resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = aws_vpc.Jenkins-VPC.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = aws_vpc.Jenkins-VPC.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Outbound rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

