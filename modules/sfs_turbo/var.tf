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

variable "sfs_turbo_size" {
}

variable "sfs_turbo_type" {
}

variable "sfs_turbo_enhanced" {
}

variable "tags" {
  default = {
   }
}
