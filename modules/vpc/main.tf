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

### Create VPC ###
resource "huaweicloud_vpc" "vpc" {
  region                 = "${var.region}"
  name                   = "${var.vpc_name}"
  cidr                   = "${var.vpc_cidr}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  tags                   = "${var.tags}"

}

### Create subnet ###
resource "huaweicloud_vpc_subnet" "subnet" {
  name          = "${var.subnet_name}"
  cidr          = "${var.subnet_cidr}"
  gateway_ip    = "${var.subnet_gateway_ip}"
  vpc_id        = "${huaweicloud_vpc.vpc.id}"
#  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  tags          = "${var.tags}"
}

## Security Group Resource ##
resource "huaweicloud_networking_secgroup" "securitygroup" {
  region               = "${var.region}"
  name                 = "${var.app_name}-${var.environment}-sg"
  description          = "${var.app_name}-${var.environment} security group"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  delete_default_rules = true
}

## Security Group Rule INGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_ingress_main" {
  for_each          = "${var.sg_ingress_rules}"
  region            = "${var.region}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = each.value.from
  port_range_max    = each.value.to
  protocol          = each.value.proto
  remote_ip_prefix  = each.value.cidr
  description       = each.value.desc
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}

resource "huaweicloud_networking_secgroup_rule" "allow_rules_ingress_elb" {
  region            = "${var.region}"
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "DO NOT DELETE. For ELB Health Checking." 
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}

## Security Group Rule EGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_egress" {
  region            = "${var.region}"
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}
