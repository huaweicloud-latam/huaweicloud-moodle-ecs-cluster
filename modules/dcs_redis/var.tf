## Application Environment variables ## 

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

## DCS Instance variables ## 

variable "dcs_cache_mode" {
}

variable "dcs_capacity" {
}

variable "dcs_cpu_architecture" {
}

variable "dcs_type" {
}

variable "dcs_version" {
}

variable "dcs_init_password" {
}

variable "dcs_backup_days" {
}

variable "dcs_backup_starttime" {
}

variable "dcs_backup_keepdays" {
}
