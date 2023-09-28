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

data "huaweicloud_images_image" "image_main" {
  name        = "${var.app_name}-${var.environment}-image"
  visibility  = "private"
  most_recent = true
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


data "huaweicloud_networking_secgroup" "securitygroup" {
  name        = "${var.app_name}-${var.environment}-sg"
}

data "huaweicloud_compute_flavors" "flavors" {
  availability_zone = "${var.availability_zone}"
  generation        = "${var.ecs_generation}"
  cpu_core_count    = "${var.cpu_core_count}"
  memory_size       = "${var.memory_size}"
}


resource "huaweicloud_as_configuration" "as_conf_main" {
  scaling_configuration_name = "${var.app_name}-${var.environment}-as_conf"

  instance_config {
    flavor        = "${data.huaweicloud_compute_flavors.flavors.ids[0]}"
    image            = "${data.huaweicloud_images_image.image_main.id}"
    key_name         = "${var.region}-keypair"
 
    disk {
      size        = "${var.ecs_sysdisk_size}"
      volume_type = "${var.ecs_sysdisk_type}"
      disk_type   = "SYS"
    }
  }
}

resource "huaweicloud_as_group" "as_group_main" {
  scaling_group_name       = "${var.app_name}-${var.environment}-as_group"
  scaling_configuration_id = "${huaweicloud_as_configuration.as_conf_main.id}"
  desire_instance_number   = "${var.desire_instance_number}"
  min_instance_number      = "${var.min_instance_number}"
  max_instance_number      = "${var.max_instance_number}"
  vpc_id                   = "${data.huaweicloud_vpc.vpc.id}"
  available_zones          = ["${var.availability_zone1}", "${var.availability_zone2}"]
  delete_publicip          = true
  delete_instances         = "yes"
  force_delete             = true
  enterprise_project_id      = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  networks {
    id = "${data.huaweicloud_vpc_subnet.subnet.id}"
  }

  security_groups {
    id = "${data.huaweicloud_networking_secgroup.securitygroup.id}"
  }

  lbaas_listeners {
    pool_id = "${var.elb_http_pool_id}"
    protocol_port = 80
  }

  lbaas_listeners {
    pool_id = "${var.elb_https_pool_id}"
    protocol_port = 80 
  }


}

resource "huaweicloud_as_policy" "as_policy_main" {
  scaling_policy_name = "${var.app_name}-${var.environment}-as_policy"
  scaling_policy_type = "RECURRENCE"
  scaling_group_id    = "${huaweicloud_as_group.as_group_main.id}"
  cool_down_time      = 900

  scaling_policy_action {
    operation       = "ADD"
    instance_number = 1
  }
  scheduled_policy {
    launch_time = "07:00"
    recurrence_type = "Daily"
    start_time      = "2022-07-21T12:00Z"
    end_time        = "2023-07-30T12:00Z"
  }
}
