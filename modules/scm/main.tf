### Provider Huawei Cloud ##
terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

### The certificates is stored in the PATH entry/${var.app_name}-${var.environment}_ca.crt ###
### The certificates chain is stored in the PATH entry/${var.app_name}-${var.environment}_ca_chain.crt ###
### The private key is stored in the PATH entry/${var.app_name}-${var.environment}_private_key.crt ###

resource "huaweicloud_scm_certificate" "certificate" {
### SSL Certificate Manager (SCM) Endpoint scm.ap-southeast-1.myhuaweicloud.com ###
  region            = "ap-southeast-1"
  name              = "${var.app_name}_${var.environment}_cert"
### The parameter of certificate includes the firt segment of certificate ###
  certificate       = file("${path.root}/${var.app_name}_${var.environment}_ca.crt")
### The parameter of certificate_chain includes the second  and third segments of certificate ###
  certificate_chain = file("${path.root}/${var.app_name}_${var.environment}_ca_chain.crt")
### The parameter of private_key includes the private key of certificate ###
  private_key       = file("${path.root}/${var.app_name}_${var.environment}_private_key.crt")

  target {
    project  = ["${var.region}"]
    service  = "Enhance_ELB"
  }

### Push certificates to WAF Service ###
### Before you push, please purchase the WAF service first on WAF Console ###
#  target {
#    project  = ["${var.region}"]
#    service  = "WAF"
#  }

### Push certificates to WAF Service ###
#  target {
#    service  = "CDN"
#  }

}
