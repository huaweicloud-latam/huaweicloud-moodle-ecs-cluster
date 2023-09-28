### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

resource "huaweicloud_enterprise_project" "enterprise_project" {
  name                    = "${var.app_name}-${var.environment}"
  description             = "${var.app_name} ${var.environment} Enterprise Project"
  enable                  = true
  skip_disable_on_destroy = true

}
