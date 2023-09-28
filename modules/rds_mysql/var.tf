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

## Application Environment variables ## 

variable "app_name" {
}

variable "environment" {
}

variable "tags"{
  default = {
  }
}

## RDS Instance variables ## 

variable "rds_db_type" {
}

variable "rds_db_version" {
}

variable "rds_instance_mode" {
}

variable "rds_group_type" {
}

variable "rds_vcpus" {
}

variable "rds_memory" {
}

variable "rds_replication_mode" {
}

variable "rds_init_password" {
}

variable "rds_volume_type" {
}

variable "rds_volume_size" {
}

variable "rds_backup_starttime" {
}

variable "rds_backup_keepdays" {
}

variable "time_zone" {
}
