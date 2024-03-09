# Getting all the necessary IDs

output "vpc_id" {
  value = aws_vpc.Jenkins-VPC.id
}

output "Expansion-Pub-Sub1_id" {
  value = aws_subnet.Pub-Sub1.id
}

output "Expansion-Pub-Sub2_id" {
  value = aws_subnet.Pub-Sub2.id
}

output "Expansion-Priv-Sub1_id" {
  value = aws_subnet.Priv-Sub1.id
}

output "Expansion-Priv-Sub2_id" {
  value = aws_subnet.Priv-Sub2.id
}

output "Expansion-Pub-RT_id" {
  value = aws_route_table.Pub-RT.id
}

output "Expansion-Priv-RT_id" {
  value = aws_route_table.Priv-RT.id
}

output "Expansion-igw_id" {
  value = aws_internet_gateway.igw.id
}

output "Expansion-Nat-eip_id" {
  value = aws_eip.eip.id
}

output "Expansion-Nat-gateway_id" {
  value = aws_nat_gateway.ngw.id
}

output "Expansion-EC2-Insance_id" {
  value = aws_instance.Jenkins-EC2.id
}