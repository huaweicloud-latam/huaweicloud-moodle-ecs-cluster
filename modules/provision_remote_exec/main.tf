### Provider Huawei Cloud ## 

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}


data "huaweicloud_compute_instance" "ecs_generic_instance" {
  name = "${var.app_name}-${var.environment}-ecs"
}

## Provisioner for LAMP auto-installation-scripts.sh  ##
resource "null_resource" "provision" {

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      agent       = false
      user        = "root"
      private_key = file("${path.root}/${var.private_key_file}") ## Please place the private_key in the PATH "entry/XXXX" ##
      host        = "${data.huaweicloud_compute_instance.ecs_generic_instance.public_ip}"  ## the EIP address of the ECS ##
    }

    inline = [
      ### Execute the commands in the Target ECS ###
      "chmod 744 ${var.remote_exec_path}/${var.remote_exec_filename}",  
      "bash ${var.remote_exec_path}/${var.remote_exec_filename}"  
    ]
  }
}
