## Region and Availability zone variables ##

variable "region" {
}

variable "availability_zone" {
}

variable "availability_zone1" {
}

variable "availability_zone2" {
}

## Network variables ##

variable "vpc_name" {
}

variable "subnet_name" {
}

## Instance variables ## 

variable "app_name" {
}

variable "environment" {
}

## Autoscaling Configuration variables ##

variable "ecs_generation" {
}

variable "cpu_core_count" {
}

variable "memory_size" {
}

variable "ecs_sysdisk_type" {
}

variable "ecs_sysdisk_size" {
}

## Autoscaling Group variables ##

variable "desire_instance_number" {
}

variable "min_instance_number" {
}

variable "max_instance_number" {
}

variable "elb_http_pool_id" {
}

variable "elb_https_pool_id" {
}
