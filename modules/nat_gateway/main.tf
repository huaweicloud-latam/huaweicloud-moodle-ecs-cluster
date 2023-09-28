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

data "huaweicloud_vpc" "vpc" {
  name        = "${var.vpc_name}"
}


data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


resource "huaweicloud_vpc_eip" "nat_gateway_eip" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.app_name}-${var.environment}-nat-gateway"
    size        = "${var.nat_gateway_bandwidth_size}"
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_gateway" "nat_gateway_main" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  name                = "${var.app_name}-${var.environment}-nat-gateway"
  region              = "${var.region}"
  spec                = "${var.nat_gateway_type}"
  subnet_id           = "${data.huaweicloud_vpc_subnet.subnet.id}"
  vpc_id              = "${data.huaweicloud_vpc.vpc.id}"
}

resource "huaweicloud_nat_snat_rule" "snat_main" {
  region         = "${var.region}"
  nat_gateway_id = "${huaweicloud_nat_gateway.nat_gateway_main.id}"
  subnet_id      = "${data.huaweicloud_vpc_subnet.subnet.id}"
  floating_ip_id = "${huaweicloud_vpc_eip.nat_gateway_eip.id}"
}
