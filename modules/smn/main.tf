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

resource "huaweicloud_smn_topic" "topic_alarm" {
  name         = "${var.app_name}-${var.environment}-topic-alarm"
  display_name = "${var.app_name}-${var.environment}-topic-alarm"
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
}

resource "huaweicloud_smn_subscription" "subscription_email" {
  topic_urn = "${huaweicloud_smn_topic.topic_alarm.id}"
  endpoint  = "${var.alarm_email_address}"
  protocol  = "email"
  remark    = "O&M"
}
