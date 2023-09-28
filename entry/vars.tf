### Credentials received from terraform.tfvars file ###

variable "ak" {}
variable "sk" {}

### Application Environment variables ### 
variable "app_name" {
    default = "moodle"
}

variable "environment" {
  default = "production"
}

variable "time_zone" {
  default = "UTC-05:00"
}

## Whether the Enterprise Project exists? Exist=0; Not Exist=1 ##
variable "enterprise_project_exist" {
  default = "0"
}

### Region and Availability zone variables ###

variable "region" {
    default = "la-south-2"
#    default = "sa-brazil-1"
#    default = "la-north-2"
}

variable "number_of_azs" {
  default = "2"
}

variable "availability_zone1" {
    default = "la-south-2a"
#    default = "sa-brazil-1a"
#    default = "la-north-2a"
}

variable "availability_zone2" {
    default = "la-south-2b"
#    default = "sa-brazil-1b"
#    default = "la-north-2a"
}

### Network variables ###

variable "vpc_name" {
    default = "vpc_moodle"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "subnet_name" {
    default = "subnet_moodle"
}

variable "subnet_cidr" {
    default = "10.10.1.0/24"
}

variable "subnet_gateway_ip" {
    default = "10.10.1.1"
}

### Security Group variable ### 

variable "sg_ingress_rules" {
    type        = map(map(any))
    default     = {
        rule1 = {from=22, to=22, proto="tcp", cidr="0.0.0.0/0", desc="SSH Remotely Login from Internet for Linux"}
        rule2 = {from=3389, to=3389, proto="tcp", cidr="0.0.0.0/0", desc="RDP Remotely Login from Internet for Windows"}
        rule3 = {from=80, to=80, proto="tcp", cidr="0.0.0.0/0", desc="Access Webserver HTTP from Internet"}
        rule4 = {from=443, to=443, proto="tcp", cidr="0.0.0.0/0", desc="Access Webserver HTTPs from Internet"}
        rule5 = {from=3306, to=3306, proto="tcp", cidr="10.10.0.0/16", desc="Access RDS from the VPC CIDR"}
        rule6 = {from=6379, to=6379, proto="tcp", cidr="10.10.0.0/16", desc="Access VPC from the VPC CIDR"}
    }
}

### ECS Instance variables ### 

## Specifies the ECS flavor type. Possible values are as follows: ##
## normal:      General computing ##
## computingv3: General computing-plus ##
## highmem:     Memory-optimized ##
#variable "ecs_performance_type" {
#  default = "normal"
#}

variable "ecs_generation" {
  default = "s6"
}

## Specifies the number of vCPUs in the ECS flavor ##
variable "cpu_core_count" {
  default = "1"
}

## Specifies the memory size(GB) in the ECS flavor ##
variable "memory_size" {
  default = "2"
}

## Specifies the Public Image Name ##
variable "ecs_image_name" {
  default = "Debian 10.0.0 64bit"
}

variable "ecs_image_type" {
  default = "public"
}

## Specifies the system disk type of the instance ##
## SAS  : High I/O disk type ##
## GPSSD: General purpose SSD disk type ##
## SSD  : Ultra-high I/O disk type ##
## ESSD : Extreme SSD type, Santiago Region supports ##
variable "ecs_sysdisk_type" {
  default = "SAS"
}

variable "ecs_sysdisk_size" {
  default = "40"
}

## Numbers of Datadisk ##
variable "ecs_datadisk_number" {
  default = "0"
}

variable "ecs_datadisk_type" {
  default = "GPSSD"
}

variable "ecs_datadisk_size" {
  default = "100"
}

## SSH PUBLIC KEY - Place the key in terraform_root_path  entry/ ##
variable "public_key_file" {
    default = "id_rsa.pub"
}

## Elastic IP variables ##
variable "ecs_attach_eip" {
  default = false
}

variable "ecs_image_attach_eip" {
  default = true
}

variable "eip_bandwidth_size" {
  default = "50"
}

### CBR variables ###

## Specifies the CBR vault sapacity for ECS, in GB. The valid value range is 1 to 10,485,760 ##
variable "cbr_ecs_vault_size" {
    default = "100"
}

## Specifies the CBR vault capacity for SFS Turbo, in GB. The valid value range is 1 to 10,485,760 ##
variable "cbr_sfs_turbo_vault_size" {
    default = "100"
}
 
##  Specifies the backup time TIMEZONE: UTC-0 ##
variable "cbr_ecs_backup_starttime" {
  default = "05:00"
}

##  Specifies the backup time TIMEZONE: UTC-0 ##
variable "cbr_sfs_backup_starttime" {
  default = "05:00"
}

## Specifies the duration (in days) for CBR ECS retained backups. The value ranges from 2 to 99,999 ##
variable "ecs_retention_time_period" {
  default = "90"
}

## Specifies the duration (in days) for CBR SFS Turbo retained backups. The value ranges from 2 to 99,999 ##
variable "sfs_retention_time_period" {
  default = "180"
}

### SMN variable ###

variable "alarm_email_address" {
    default = "abcd@abc.com"
}

### Provsion variable ###

## Place the key in terraform_root_path  entry/ ##
variable "private_key_file" {
  default = "id_rsa"
}

##  PATH /root ##
variable "remote_exec_path" {
  default = "/root"
}

## Place the key in terraform_root_path  entry/ ##
variable "remote_exec_filename" {
  default = "auto_installation_ecs_cluster.sh"
}

### SCM Certificate variables ###
variable "cert_path" {
  default = "/opt/certpath/"
}

### ELB common varialbes ###
variable "elb_bandwidth_size" {
  default = "50"
}

## Variables for Shared ELB ##

variable "elb_attach_eip" {
  default = true
}

## Varialbes for Dedicated ELB ##
## ELB Flavor and Max connections Mapping ##
## Small   I  - Maximum Connections:  200000 ##
## Small   II - Maximum Connections:  400000 ##
## Medium  I  - Maximum Connections:  800000 ##
## Medium  II - Maximum Connections: 2000000 ##
## Large   I  - Maximum Connections: 4000000 ##
## Large   II - Maximum Connections: 8000000 ##

variable "elb_max_connections" {
  default = "200000"
}

### RDS variables ###

## RDS Instance Type ##
## rds.mysql.n1.large.2.ha 2C4G ##
## rds.mysql.n1.xlarge.2.ha 4C8G ##
## rds.mysql.n1.2xlarge.2.ha 8C16G ##

variable "rds_db_type" {
  default = "MySQL"
}

variable "rds_db_version" {
  default = "5.7"
}

variable "rds_instance_mode" {
  default = "ha"
}

## General type: general ##
## Dedicated type: dedicated ##
variable "rds_group_type" {
  default = "dedicated"
}

variable "rds_vcpus" {
  default = "2"
}

variable "rds_memory" {
  default = "8"
}

## For MySQL, the value is async or semisync. ##
variable "rds_replication_mode" {
  default = "async"
}

variable "rds_init_password" {
  default = "Abew!145"
}

variable "rds_volume_type" {
  default = "CLOUDSSD"
}

variable "rds_volume_size" {
  default = "100"
}

## Specifies RDS backup Start Time  TIMEZONE: UTC-0 ##
## It must be a valid value in the hh:mm-HH:MM format. The current time is in the UTC format. The HH value must be 1 greater than the hh value. ##
variable "rds_backup_starttime" {
  default = "05:15-06:15"
}

variable "rds_backup_keepdays" {
  default = "180"
}


### DCS Redis variables ###

variable "dcs_type" {
  default = "Redis"
}

variable "dcs_version" {
  default = "5.0"
}

## DCS CACHE MODE ##
## single      - Single Node    ##
## ha          - Master/Standby ##
## cluster     - Redis Cluster ##
variable "dcs_cache_mode" {
  default = "ha"
}

## DCS CAPACITY SIZE UNIT Gbit/s ##
## Redis 5.0: Single-node supports values: 0.125, 0.25, 0.5, 1, 2, 4, 8, 16, 32 and 64 ##
## Redis 5.0: Master/Standby supports values: 1, 2, 4, 8, 16, 32 and 64 ##
## Redis 5.0: Redis Cluster supports values: 4, 8, 16, 24, 32, 48, 64, 96, 128, 192, 256, 384, 512, 768 and 1024 ##
variable "dcs_capacity" {
  default = "4"
}

## The CPU architecture of cache instance. Valid values x86_64 and aarch64 ##
variable "dcs_cpu_architecture" {
  default = "x86_64"
}

variable "dcs_init_password" {
  default = "Abew@145"
}

## Day in a week on which backup starts, the value ranges from 1 to 7. Where: 1 indicates Monday; 7 indicates Sunday ##
variable "dcs_backup_days" {
  default = [1, 2, 3, 4, 5, 6, 7]
}

## Format must be HH:00-HH:00 TIMEZONE: UTC-0##
variable "dcs_backup_starttime" {
  default = "05:00-06:00"
}

## Retention time. Unit: day, the value ranges from 1 to 7 ##
variable "dcs_backup_keepdays" {
  default = "7"
}

### SFS Turbo varaiables ###

## SFS Turbo Type: STANDARD / PERFORMANCE ##
variable "sfs_turbo_type" {
  default = "STANDARD"
}

## Select SFS Turbo Normal or Enhanced: false or true ##
variable "sfs_turbo_enhanced" {
  default = false
}

## The value ranges capacity is from 500 GB to 32768 GB ##
## Must be larger than   500 GB for STANDARD or PERFORMANCE ##
## Must be larger than 10240 GB for STANDARD ENHANCED or PERFORMANCE ENHANCED ##
variable "sfs_turbo_size" {
  default = "500"
}

### NATGATEWAY variables ###

## NATGATEWAY TYPE 1: Small Type, 2: Medium Type, 3: Large Type, 4: Extra Type ##
variable "nat_gateway_type" {
  default = "1"
}

## NATGATEWAY BANDWIDTH SIZE, unit Mbit/s ##
variable "nat_gateway_bandwidth_size" {
  default = "100"
}

### Autoscaling variables ###
## The expected number of instances.  ##
variable "desire_instance_number" {
  default = "1"
}

## The minimum number of instances. ##
variable "min_instance_number" {
  default = "1"
}
## The maximum number of instances. ##
variable "max_instance_number" {
  default = "3"
}

## The cooling duration (in seconds), and is 900 by default. ##
variable "cool_down_time" {
  default = "900"
}

## The time when the scaling action is triggered. ##
variable "launch_time" {
  default = "07:00"
}

## The options include Daily, Weekly, and Monthly. ##
variable "recurrence_type" {
  default = "Daily"
}

## The start time of the scaling action triggered periodically. The time format complies with UTC. The current time is used by default. The time format is YYYY-MM-DDThh:mmZ. ##
variable "start_time" {
  default = "2022-07-21T12:00Z"
}

## The end time of the scaling action triggered periodically. The time format complies with UTC. The time format is YYYY-MM-DDThh:mmZ. ##
variable "end_time" {
  default = "2023-07-30T12:00Z"
}
