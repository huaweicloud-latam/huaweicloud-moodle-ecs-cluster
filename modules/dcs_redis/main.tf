### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

data "huaweicloud_enterprise_project" "enterprise_project" {
  name = "${var.app_name}-${var.environment}"
}

data "huaweicloud_availability_zones" "zones" {
  region      = "${var.region}"
}

data "huaweicloud_vpcs" "vpcs_main" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc" "vpc_main" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


data "huaweicloud_networking_secgroup" "securitygroup" {
  name        = "${var.app_name}-${var.environment}-sg"
}

data "huaweicloud_dcs_flavors" "dcs_redis_flavors" {
  cache_mode       = "${var.dcs_cache_mode}"
  capacity         = "${var.dcs_capacity}"
  cpu_architecture = "${var.dcs_cpu_architecture}"
  engine_version   = "${var.dcs_version}"
}

##  For Single Mode DCS Instance && Region has only one AZ ##
resource "huaweicloud_dcs_instance" "dcs_redis_region1az_single_mode" {
  count              = var.number_of_azs == "1" && var.dcs_cache_mode == "single" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}

##  For Single Mode DCS Instance && Region has more than 2 AZs ##
resource "huaweicloud_dcs_instance" "dcs_redis_region2azs_single_mode" {
  count              = var.number_of_azs >= 2 && var.dcs_cache_mode == "single" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}

##  For Master/Standy Mode or Cluster Mode Instance && Region has only one AZ ##
resource "huaweicloud_dcs_instance" "dcs_redis_region1az_ha_mode" {
  count              = var.number_of_azs == "1" && var.dcs_cache_mode == "ha" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone1}", "${var.availability_zone1}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  backup_policy {
    backup_type = "auto"
    save_days   = "${var.dcs_backup_keepdays}"
    backup_at   = "${var.dcs_backup_days}"
    begin_at    = "${var.dcs_backup_starttime}"
  }

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}


##  For Master/Standy Mode or Cluster Mode Instance && Region has more than 2 AZs ##
resource "huaweicloud_dcs_instance" "dcs_redis_region2azs_ha_mode" {
  count              = var.number_of_azs >= 2 && var.dcs_cache_mode == "ha" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone1}", "${var.availability_zone2}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  backup_policy {
    backup_type = "auto"
    save_days   = "${var.dcs_backup_keepdays}"
    backup_at   = "${var.dcs_backup_days}"
    begin_at    = "${var.dcs_backup_starttime}"
  }

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}

##  For Cluster Mode Instance && Region has only one AZ ##
resource "huaweicloud_dcs_instance" "dcs_redis_region1az_cluster_mode" {
  count              = var.number_of_azs == "1" && var.dcs_cache_mode == "cluster" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone1}", "${var.availability_zone1}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  backup_policy {
    backup_type = "auto"
    save_days   = "${var.dcs_backup_keepdays}"
    backup_at   = "${var.dcs_backup_days}"
    begin_at    = "${var.dcs_backup_starttime}"
  }

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}


##  For Cluster Mode Instance && Region has more than 2 AZs ##
resource "huaweicloud_dcs_instance" "dcs_redis_region2azs_cluster_mode" {
  count              = var.number_of_azs >= 2 && var.dcs_cache_mode == "cluster" ? 1 : 0
  name               = "${var.app_name}-${var.environment}-dcs"
  engine             = "${var.dcs_type}"
  engine_version     = "${var.dcs_version}"
  capacity           = "${var.dcs_capacity}"
  flavor             = "${data.huaweicloud_dcs_flavors.dcs_redis_flavors.flavors[0].name}"
  availability_zones = ["${var.availability_zone1}", "${var.availability_zone2}"]
  password           = "${var.dcs_init_password}"
  vpc_id             = "${data.huaweicloud_vpc.vpc_main.id}"
  subnet_id          = "${data.huaweicloud_vpc_subnet.subnet.id}"
  whitelist_enable   = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  backup_policy {
    backup_type = "auto"
    save_days   = "${var.dcs_backup_keepdays}"
    backup_at   = "${var.dcs_backup_days}"
    begin_at    = "${var.dcs_backup_starttime}"
  }

  whitelists {
    group_name = "${var.vpc_name}-whitelist-group"
    ip_address = ["${data.huaweicloud_vpcs.vpcs_main.vpcs[0].cidr}"]
  }
}
