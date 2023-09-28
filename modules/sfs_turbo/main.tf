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

data "huaweicloud_vpc" "vpc" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


data "huaweicloud_networking_secgroup" "securitygroup" {
  name        = "${var.app_name}-${var.environment}-sg"
}


resource "huaweicloud_sfs_turbo" "sfs_turbo_main" {
  name              = "${var.app_name}-${var.environment}-sfs-turbo"
  region            = "${var.region}"
  size              = "${var.sfs_turbo_size}"
  share_proto       = "NFS"
  share_type        = "${var.sfs_turbo_type}"
  vpc_id            = "${data.huaweicloud_vpc.vpc.id}"
  subnet_id         = "${data.huaweicloud_vpc_subnet.subnet.id}"
  security_group_id = "${data.huaweicloud_networking_secgroup.securitygroup.id}"
  availability_zone = "${var.availability_zone}"
#  availability_zone = "${data.huaweicloud_availability_zones.zones.names[0]}"
  enhanced          = "${var.sfs_turbo_enhanced}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
}
