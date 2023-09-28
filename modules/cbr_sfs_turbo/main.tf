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

resource "huaweicloud_cbr_policy" "cbr_sfs_turbo_policy_main" {
  name        = "${var.app_name}-${var.environment}-sfs_turbo-cbr-policy"
  type        = "backup"
  time_period = "${var.retention_time_period}"
  time_zone    = "${var.time_zone}"

  backup_cycle {
    interval        = 1
    execution_times = ["${var.cbr_sfs_backup_starttime}"]
  }
}

resource "huaweicloud_cbr_vault" "cbr_sfs_turbo_vault_main" {
  name             = "${var.app_name}-${var.environment}-sfs_turbo-cbr-vault"
  size             = "${var.cbr_sfs_turbo_vault_size}"
  type             = "turbo"
  protection_type  = "backup"
  consistent_level = "crash_consistent"
  auto_expand      = true
  policy_id        = "${huaweicloud_cbr_policy.cbr_sfs_turbo_policy_main.id}"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"

  resources {
    includes = [
      "${var.sfs_turbo_id}"
    ]
  }
}
