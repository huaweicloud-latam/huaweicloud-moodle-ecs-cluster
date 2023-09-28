### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

resource "random_string" "random_suffix" {
  length  = 12
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "huaweicloud_obs_bucket" "cts_transfer_bucket" {
  bucket        = "cts-bucket-${random_string.random_suffix.result}"
  storage_class = "STANDARD"
  acl           = "private"
  force_destroy = true
}

resource "huaweicloud_cts_tracker" "tracker" {
  bucket_name = "${huaweicloud_obs_bucket.cts_transfer_bucket.id}"
  file_prefix = "cts"
  lts_enabled = true
}
