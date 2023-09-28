output "certificate_id" {
  value = "${join(",", huaweicloud_scm_certificate.certificate.*.id)}"
}
