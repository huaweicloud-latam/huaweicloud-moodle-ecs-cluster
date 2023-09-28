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

data "huaweicloud_lb_certificate" "cert-ssl" {
  name        = "${var.app_name}_${var.environment}_cert"
  type        = "server"
}

data "huaweicloud_vpcs" "vpcs_main" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


## ELB - Elastic IP Resource ##
resource "huaweicloud_vpc_eip" "instance_eip" {
  count          = "${var.elb_attach_eip ? 1 : 0}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.app_name}_${var.environment}_bandwidth"
    size        = "${var.elb_bandwidth_size}"
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

## ELB - Elastic IP Associate Resource ##
resource "huaweicloud_networking_eip_associate" "associated" {
  count       = "${var.elb_attach_eip ? 1 : 0}"
  public_ip   = "${element(huaweicloud_vpc_eip.instance_eip.*.address,count.index)}"
  port_id     = "${huaweicloud_lb_loadbalancer.loadbalancer.vip_port_id}"
}


resource "huaweicloud_lb_loadbalancer" "loadbalancer" {
  name              = "${var.app_name}-${var.environment}-elb"
  description       = "${var.app_name} ${var.environment} loadbalancer"
  ## IPv4 Subnet ID -- Native Openstack API ##
  vip_subnet_id     = "${data.huaweicloud_vpc_subnet.subnet.subnet_id}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  tags              = "${var.tags}"

}

resource "huaweicloud_lb_listener" "http_listener" {
  name              = "${var.app_name}-${var.environment}-http_listener"
  description       = "${var.app_name} ${var.environment} http listener"
  protocol          = "HTTP"
  protocol_port     = "80"
  loadbalancer_id   = "${huaweicloud_lb_loadbalancer.loadbalancer.id}"
  tags              = "${var.tags}"
}

resource "huaweicloud_lb_listener" "https_listener" {
  name                      = "${var.app_name}-${var.environment}-https_listener"
  description               = "${var.app_name} ${var.environment} https listener"
  protocol                  = "TERMINATED_HTTPS"
  protocol_port             = "443"
  loadbalancer_id           = "${huaweicloud_lb_loadbalancer.loadbalancer.id}"
  default_tls_container_ref = "${data.huaweicloud_lb_certificate.cert-ssl.id}"
  tags                      = "${var.tags}"
}

resource "huaweicloud_lb_pool" "https_pool" {
  name              = "${var.app_name}-${var.environment}-pool"
  description       = "${var.app_name} ${var.environment} https pool"
  protocol          = "HTTP"
  listener_id       = "${huaweicloud_lb_listener.https_listener.id}"
  lb_method         = "ROUND_ROBIN"
  
  persistence {
    type = "HTTP_COOKIE"
  }

}

resource "huaweicloud_lb_pool" "http_pool" {
  name              = "${var.app_name}-${var.environment}-pool"
  description       = "${var.app_name} ${var.environment} http  pool"
  protocol          = "HTTP"
  listener_id       = "${huaweicloud_lb_listener.http_listener.id}"
  lb_method         = "ROUND_ROBIN"

  persistence {
    type = "HTTP_COOKIE"
  }
}

resource "huaweicloud_lb_monitor" "https_pool_healthcheck" {
  name              = "${var.app_name}-${var.environment}-healthcheck"
  pool_id           = "${huaweicloud_lb_pool.https_pool.id}"
#  type              = "HTTP"
#  delay             = "5"
#  timeout            = "3"
#  max_retries       = "3"
#  port              = "80"
#  url_path          = "/install.php"
#  http_method       = "GET"
#  expected_codes    = "200-202"
  type              = "TCP"
  delay             = "5"
  timeout            = "3"
  max_retries       = "3"
  port              = "80"
}
resource "huaweicloud_lb_monitor" "http_pool_healthcheck" {
  name              = "${var.app_name}-${var.environment}-healthcheck"
  pool_id           = "${huaweicloud_lb_pool.http_pool.id}"
#  type              = "HTTP"
#  delay             = "5"
#  timeout            = "3"
#  max_retries       = "3"
#  port              = "80"
#  url_path          = "/install.php"
#  http_method       = "GET"
#  expected_codes    = "200-202"
  type              = "TCP"
  delay             = "5"
  timeout            = "3"
  max_retries       = "3"
  port              = "80"
}
