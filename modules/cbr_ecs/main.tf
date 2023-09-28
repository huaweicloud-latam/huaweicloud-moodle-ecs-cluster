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

data "huaweicloud_compute_instances" "ecs_generic_instances" {
  region      = "${var.region}"
}

resource "huaweicloud_cbr_policy" "cbr_ecs_policy_main" {
  name        = "${var.app_name}-${var.environment}-server-cbr-policy"
  type        = "backup"
  time_period = "${var.retention_time_period}"
  time_zone    = "${var.time_zone}"

  backup_cycle {
    interval        = 1
    execution_times = ["${var.cbr_ecs_backup_starttime}"]
  }
}

resource "huaweicloud_cbr_vault" "cbr_ecs_vault_main" {
  name             = "${var.app_name}-${var.environment}-server-cbr-vault"
  size             = "${var.cbr_ecs_vault_size}"
  type             = "server"
  protection_type  = "backup"
  consistent_level = "crash_consistent"
  auto_expand      = true
  policy_id        = "${huaweicloud_cbr_policy.cbr_ecs_policy_main.id}"
  auto_bind        = true
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  dynamic "resources" {
    for_each  = "${var.ecs_instances_ids}"
    content {
      server_id = resources.value
    }
  }
}
