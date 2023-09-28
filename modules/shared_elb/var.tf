## Application variables ##

variable "app_name" {
}

variable "environment" {
}

variable "tags"{
  default = {
  }
}

## Region and Availability zone variables ##

variable "region" {
}

## Network variables ##

variable "vpc_name" {
}

variable "subnet_name" {
}

## Elastic IP variables ##

variable "elb_attach_eip" {
}

variable "elb_bandwidth_size" {
}

