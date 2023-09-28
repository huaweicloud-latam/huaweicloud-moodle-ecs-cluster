## application environment variables ##

variable "app_name" {
}

variable "environment" {
}

variable "tags" {
  default = {
  }
}

## Region and Availability zone variables ##

variable "region" {
}

## Network variables ##

variable "vpc_name" {
}

variable "vpc_cidr" {
}

variable "subnet_name" {
}

variable "subnet_cidr" {
}

variable "subnet_gateway_ip" {
}

## Security Group variable ##

variable "sg_ingress_rules" {
}
