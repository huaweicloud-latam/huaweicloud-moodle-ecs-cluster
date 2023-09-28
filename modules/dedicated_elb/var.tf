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

variable "vpc_name" {
}

variable "subnet_name" {
}

## Instance variables ##

variable "app_name" {
}

variable "environment" {
}

variable "tags"{
  default = {
  }
}

## Elastic LB  variables ##
variable "elb_bandwidth_size" {
}

variable "elb_max_connections" {
}

variable "eip_type_5_gray" {
  default = "5_gray"
}

variable "eip_type_5_bgp" {
  default = "5_bgp"
}
