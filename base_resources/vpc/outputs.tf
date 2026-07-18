output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids_list" {
  value = module.vpc.private_subnet_ids_list
}

output "nat_gateway_ips" {
  value = module.vpc.nat_gateway_ips
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}
