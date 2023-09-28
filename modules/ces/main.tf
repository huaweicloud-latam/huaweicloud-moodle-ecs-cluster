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

data "huaweicloud_smn_topics" "topic_alarm" {
  name         = "${var.app_name}-${var.environment}-topic-alarm"
}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_eip" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    blockEIP = "1"
    unblockEIP = "4"
    EIPBandwidthOverflow = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"
  
  metric {
    namespace   = "SYS.EIP"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_ecs" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    startAutoRecovery               = "2"
    endAutoRecovery                 = "2"
    faultAutoRecovery               = "1"
    vmIsRunningImproperly           = "2"
    VMFaultsByHostProcessExceptions = "2"
    RestartGuestOS                  = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.ECS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_rds" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    DatabaseProcessRestarted         = "1"
    instanceDiskFull                 = "1"
    fullBackupFailed                 = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.RDS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_dcs" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    redisNodeStatusAbnormal         = "2"
    memcachedInstanceStatusAbnormal = "2"
    instanceNodeAbnormalRestart     = "2"
    instanceBackupFailure           = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.DCS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_cbr" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    backupFailed                  = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.CBR"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_bms" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    DatabaseProcessRestarted             = "1"
    instanceDiskFull                     = "1"
    fullBackupFailed                     = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.BMS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_obs" {
  enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  for_each = {
    deleteBucket              = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.OBS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
  alarm_actions {
    type              = "notification"
    notification_list = data.huaweicloud_smn_topics.topic_alarm.topics[*].id
  }

}
