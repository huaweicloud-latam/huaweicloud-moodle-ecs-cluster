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

data "huaweicloud_elb_certificate" "cert-ssl" {
  name        = "${var.app_name}_${var.environment}_cert"
}

data "huaweicloud_vpc" "vpc_main" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpcs" "vpcs_main" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}

data "huaweicloud_elb_flavors" "flavors" {
  type            = "L7"
  max_connections = "${var.elb_max_connections}"
}

resource "huaweicloud_elb_loadbalancer" "loadbalancer" {
  name              = "${var.app_name}-${var.environment}-elb"
  description       = "${var.app_name} ${var.environment} loadbalancer"
  cross_vpc_backend = true
  
  vpc_id            = "${data.huaweicloud_vpc.vpc_main.id}"
  ipv4_subnet_id    = "${data.huaweicloud_vpc_subnet.subnet.subnet_id}"
  
  l7_flavor_id      = "${data.huaweicloud_elb_flavors.flavors.ids[0]}"
#  availability_zone = ["${var.availability_zone1}", "${var.availability_zone2}"]
  availability_zone = ["${var.availability_zone}"]

## Waiting for EIP SRE to change the iptype from 5_gray to 5_bgp for Dedicated ELB in sa-brazil-1 region. Currently, use 5_gray for sa-brazil-1 region ##
#  iptype                = "5_bgp"
  iptype                 = "%{ if var.region == "sa-brazil-1" }${var.eip_type_5_gray}%{ else }${var.eip_type_5_bgp}%{ endif }"
  bandwidth_charge_mode  = "traffic"
  sharetype              = "PER"
  bandwidth_size         = "${var.elb_bandwidth_size}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  tags                   = "${var.tags}"
}

resource "huaweicloud_elb_listener" "http_listener" {
  name              = "${var.app_name}-${var.environment}-http_listener"
  description       = "${var.app_name} ${var.environment} http listener"
  protocol          = "HTTP"
  protocol_port     = "80"
  loadbalancer_id   = huaweicloud_elb_loadbalancer.loadbalancer.id
  idle_timeout      = 60
  request_timeout   = 60
  response_timeout  = 60
  tags              = "${var.tags}"
}

resource "huaweicloud_elb_listener" "https_listener" {
  name                = "${var.app_name}-${var.environment}-https_listener"
  description         = "${var.app_name} ${var.environment} https listener"
  protocol            = "HTTPS"
  protocol_port       = "443"
  loadbalancer_id     = huaweicloud_elb_loadbalancer.loadbalancer.id
  server_certificate  = "${data.huaweicloud_elb_certificate.cert-ssl.id}"
  tags                = "${var.tags}"
}

resource "huaweicloud_elb_pool" "https_pool" {
  name              = "${var.app_name}-${var.environment}-pool"
  description       = "${var.app_name} ${var.environment} https pool"
  protocol          = "HTTP"
  listener_id       = huaweicloud_elb_listener.https_listener.id
  lb_method         = "ROUND_ROBIN"
  
  persistence {
    type = "HTTP_COOKIE"
  }

}

resource "huaweicloud_elb_pool" "http_pool" {
  name              = "${var.app_name}-${var.environment}-pool"
  description       = "${var.app_name} ${var.environment} http pool"
  protocol          = "HTTP"
  listener_id       = huaweicloud_elb_listener.http_listener.id
  lb_method         = "ROUND_ROBIN"

  persistence {
    type = "HTTP_COOKIE"
  }
}

resource "huaweicloud_elb_monitor" "https_pool_healthcheck" {
  pool_id           = huaweicloud_elb_pool.https_pool.id
  protocol          = "TCP"
  port              = "80"
  interval          = "5"
  timeout           = "3"
  max_retries       = "3"
}
resource "huaweicloud_elb_monitor" "http_pool_healthcheck" {
  pool_id           = huaweicloud_elb_pool.http_pool.id
  protocol          = "TCP"
  port              = "80"
  interval          = "5"
  timeout           = "3"
  max_retries       = "3"
}
