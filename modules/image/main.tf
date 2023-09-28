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

data "huaweicloud_compute_instance" "ecs_instance" {
  name = "${var.app_name}-${var.environment}-ecs"
}


resource "huaweicloud_images_image" "image_main" {
  name        = "${var.app_name}-${var.environment}-image"
  instance_id = "${data.huaweicloud_compute_instance.ecs_instance.id}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
}
