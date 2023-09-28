### Provider Huawei Cloud ## 

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

### https://stackoverflow.com/questions/52628749/set-terraform-default-interpreter-for-local-exec ###
### First a snippet to detect the OS ###
locals {
  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}

### Then choose the interpreter and command based upon which OS is used ###
resource "null_resource" "provision_localexec_main" {
  provisioner "local-exec" {
    # Ensure windows always uses PowerShell, linux/mac use their default shell.
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []

    # TODO: Replace the below with the Windows and Linux command variants
    command     = local.is_windows ? "${path.root}/${var.windows_localexec_filename}" : "bash ${path.root}/${var.linux_localexec_filename}"
  }
#  triggers = {
#    # TODO: Replace this psuedocode with one or more triggers that indicate (when changed)
#    #       that the command should be re-executed.
#    "test_a" = resource.my_resource.sample
#  }
}
