output "aws_ec2_transit_arn" {
  value = aws_ec2_transit_gateway.hub.arn
}

output "tokyo_vpc_id" {
  value = module.vpc_tokyo.vpc_id
}

output "new_york_vpc_id" {
  value = module.vpc_new_york.vpc_id
}

output "london_vpc_id" {
  value = module.vpc_london.vpc_id
}

output "sao_paulo_vpc_id" {
  value = module.vpc_sao_paulo.vpc_id
}

output "australia_vpc_id" {
  value = module.vpc_australia.vpc_id
}

output "hong_kong_vpc_id" {
  value = module.vpc_hong_kong.vpc_id
}

output "california_vpc_id" {
  value = module.vpc_california.vpc_id
}

