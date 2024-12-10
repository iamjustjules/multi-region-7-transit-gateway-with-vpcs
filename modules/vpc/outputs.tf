output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "nat_gateway_ids" {
  value = [for ng in aws_nat_gateway.main : ng.id]
}

output "private_route_table_ids" {
  value = aws_route_table.private.id
}

output "security_group_id" {
  value = aws_security_group.web.id
}
