output "vpc_id" {
  value = huaweicloud_vpc.vpc.id
}
output "vpc_name" {
  value = huaweicloud_vpc.vpc.name
}

output "subnet_id" {
  value = huaweicloud_vpc_subnet.subnet.subnet_id
}
