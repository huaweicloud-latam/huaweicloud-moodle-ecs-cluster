## Region and Availability zone variables ##

variable "region" {
}

variable "number_of_azs" {
}

variable "availability_zone" {
}

variable "availability_zone1" {
}

variable "availability_zone2" {
}

## Network variables ##

variable "subnet_name" {
}

## Environment variables ## 

variable "app_name" {
}

variable "environment" {
}

### ECS variables ###

variable "ecs_generation" {
}

variable "cpu_core_count" {
}

variable "memory_size" {
}

variable "ecs_image_name" {
}

variable "ecs_image_type" {
}

variable "ecs_sysdisk_type" {
}

variable "ecs_sysdisk_size" {
}

variable "ecs_datadisk_number" {
}

variable "ecs_datadisk_type" {
}

variable "ecs_datadisk_size" {
}

### ECS Elastic IP variables ###

variable "ecs_attach_eip" {
}

variable "eip_bandwidth_size" {
}

### ECS user_data parameters ###

variable "remote_exec_path" {
}

variable "remote_exec_filename" {
}

variable "sfs_export_location"{
}
