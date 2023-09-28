output "ecs_instances_ids" {
  value = data.huaweicloud_compute_instances.ecs_instances.instances[*].id
}
output "ecs_instance_eip" {
  value = huaweicloud_compute_instance.ecs_generic_instance.public_ip
}

