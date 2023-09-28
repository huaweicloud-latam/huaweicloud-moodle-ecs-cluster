### Provider Huawei Cloud and Credentials ## 
terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
#  backend "s3" {
#    ## You should execute the command as below to declare the backend S3 AK and SK in OS ##
#    ## export AWS_ACCESS_KEY_ID="XXX"  ##
#    ## export AWS_SECRET_ACCESS_KEY="XXX" ##
#    bucket   = "l00324891-terraform-states"
#    key      = "mangement/terraform-states"
#    region   = "la-south-2"
#    endpoint = "obs.la-south-2.myhuaweicloud.com"
#
#    skip_region_validation      = true
#    skip_metadata_api_check     = true
#    skip_credentials_validation = true
#  }
}


provider "huaweicloud" {
  region      = "${var.region}"
  access_key  = "${var.ak}"
  secret_key  = "${var.sk}"
}


################ Declaring Module VPC Working #### DONE ##############

module "eps" {
  source              = "../modules/eps/"
  count               = "${var.enterprise_project_exist}"
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
}

module "vpc" {
  source              = "../modules/vpc/"
  depends_on          = [module.eps]
  region              = "${var.region}"
  vpc_name            = "${var.vpc_name}"
  vpc_cidr            = "${var.vpc_cidr}"
  subnet_name         = "${var.subnet_name}"
  subnet_cidr         = "${var.subnet_cidr}"
  subnet_gateway_ip   = "${var.subnet_gateway_ip}"  
  app_name            = "${var.app_name}"
  environment	      = "${var.environment}"
  sg_ingress_rules    = "${var.sg_ingress_rules}"
}


################## Declaring Module ECS for Image Creation Working ###### DONE ######### 

module "ecs_image" {
  source              = "../modules/ecs/"
  depends_on          = [module.vpc,module.sfs_turbo]
  region              = "${var.region}"
  number_of_azs       = "${var.number_of_azs}"
  availability_zone   = "${var.availability_zone1}"
  availability_zone1  = "${var.availability_zone1}"
  availability_zone2  = "${var.availability_zone2}"
  subnet_name         = "${var.subnet_name}"
  app_name            = "${var.app_name}"
  environment	      = "${var.environment}"
  ecs_image_name      = "${var.ecs_image_name}"
  ecs_image_type      = "${var.ecs_image_type}"
  ecs_generation      = "${var.ecs_generation}"
  cpu_core_count      = "${var.cpu_core_count}"
  memory_size         = "${var.memory_size}"
  ecs_sysdisk_type    = "${var.ecs_sysdisk_type}"
  ecs_sysdisk_size    = "${var.ecs_sysdisk_size}"
  ecs_datadisk_number = "${var.ecs_datadisk_number}"
  ecs_datadisk_type   = "${var.ecs_datadisk_type}"
  ecs_datadisk_size   = "${var.ecs_datadisk_size}"
  ecs_attach_eip      = "${var.ecs_image_attach_eip}"
  eip_bandwidth_size  = "${var.eip_bandwidth_size}"
  remote_exec_path    = "${var.remote_exec_path}"
  remote_exec_filename= "${var.remote_exec_filename}"
  sfs_export_location = "${module.sfs_turbo.sfs_export_location}"
}

################## Declaring Module provisioner Working #### DONE ###########

module "provision_remote_exec_image" {
  source              = "../modules/provision_remote_exec/"
  depends_on          = [module.ecs_image]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  ecs_instance_eip    = "${module.ecs_image.ecs_instance_eip}"
  private_key_file    = "${var.private_key_file}"
  remote_exec_path    = "${var.remote_exec_path}"
  remote_exec_filename= "${var.remote_exec_filename}"
}

################## Declaring Module IMAGE Working #### DONE ########### 

module "image" {
  source              = "../modules/image/"
  depends_on          = [module.provision_remote_exec_image]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
}

#################### Declaring Module CTS Working ##### DONE ########## 

module "cts" {
  source              = "../modules/cts/"
}

#################### Declaring Module SMN Working ##### DONE ########## 

module "smn" {
  source              = "../modules/smn/"
  depends_on          = [module.eps]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  alarm_email_address = "${var.alarm_email_address}"
}

##################### Declaring Module CES Working ##### DONE ########## 

module "ces" {
  source              = "../modules/ces/"
  depends_on          = [module.smn]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
}

##################### Declaring Module CBR For ECS Working ##### DONE ########## 

module "cbr_ecs" {
  source                      = "../modules/cbr_ecs/"
  depends_on                  = [module.ecs_image]
  app_name                    = "${var.app_name}"
  environment                 = "${var.environment}"
  region                      = "${var.region}"
  time_zone                   = "${var.time_zone}"
  cbr_ecs_vault_size          = "${var.cbr_ecs_vault_size}"
  retention_time_period       = "${var.ecs_retention_time_period}"
  cbr_ecs_backup_starttime    = "${var.cbr_ecs_backup_starttime}"
  ecs_instances_ids           = "${module.ecs_image.ecs_instances_ids}"
}

#################### Declaring Module CBR For ECS Working ##### DONE ########## 

module "cbr_sfs_turbo" {
  source                      = "../modules/cbr_sfs_turbo/"
  depends_on                  = [module.sfs_turbo]
  app_name                    = "${var.app_name}"
  environment                 = "${var.environment}"
  region                      = "${var.region}"
  time_zone                   = "${var.time_zone}"
  cbr_sfs_turbo_vault_size    = "${var.cbr_sfs_turbo_vault_size}"
  retention_time_period       = "${var.sfs_retention_time_period}"
  cbr_sfs_backup_starttime    = "${var.cbr_sfs_backup_starttime}"
  sfs_turbo_id                = "${module.sfs_turbo.sfs_turbo_id}"
}

################# Declaring Module SCM Working ####### DONE ########

module "scm" {
  source               = "../modules/scm/"
  region               = "${var.region}"
  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
}

################### Declaring Module Shared ELB Working #### DONE ##############
# ## Region: la-south-2 / sa-brazil-1 support Shared ELB ##
#module "shared_elb" {
#  source              = "../modules/shared_elb/"
#  depends_on          = [module.vpc]
#  app_name            = "${var.app_name}"
#  environment         = "${var.environment}"
#  region              = "${var.region}"
#  vpc_name            = "${var.vpc_name}"
#  subnet_name         = "${var.subnet_name}"
#  elb_attach_eip      = "${var.elb_attach_eip}"
#  elb_bandwidth_size  = "${var.elb_bandwidth_size}"
#}
#
################## Declaring Module Dedicated ELB Working #### DONE ##############
 ## Region: la-south-2 / sa-brazil-1 / la-north-2 support Dedicated ELB ##
module "dedicated_elb" {
  source              = "../modules/dedicated_elb/"
  depends_on          = [module.vpc]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  region              = "${var.region}"
  number_of_azs       = "${var.number_of_azs}"
  availability_zone   = "${var.availability_zone1}"
  availability_zone1  = "${var.availability_zone1}"
  availability_zone2  = "${var.availability_zone2}"
  vpc_name            = "${var.vpc_name}"
  subnet_name         = "${var.subnet_name}"
  elb_bandwidth_size  = "${var.elb_bandwidth_size}"
  elb_max_connections = "${var.elb_max_connections}"
}

################# Declaring Module NATGATEWAY Working #### DONE ##############

module "nat_gateway" {
  source                     = "../modules/nat_gateway/"
  depends_on                 = [module.vpc]
  app_name                   = "${var.app_name}"
  environment                = "${var.environment}"
  region                     = "${var.region}"
  vpc_name                   = "${var.vpc_name}"
  subnet_name                = "${var.subnet_name}"
  nat_gateway_type           = "${var.nat_gateway_type}"
  nat_gateway_bandwidth_size = "${var.nat_gateway_bandwidth_size}"
}


################ Declaring Module RDS Working #### DONE ##############

module "rds_mysql" {
  source               = "../modules/rds_mysql/"
  depends_on           = [module.vpc]
  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  region               = "${var.region}"
  number_of_azs        = "${var.number_of_azs}"
  availability_zone    = "${var.availability_zone1}"
  availability_zone1   = "${var.availability_zone1}"
  availability_zone2   = "${var.availability_zone2}"
  vpc_name             = "${var.vpc_name}"
  subnet_name          = "${var.subnet_name}"
  rds_db_type          = "${var.rds_db_type}"
  rds_db_version       = "${var.rds_db_version}"
  rds_instance_mode    = "${var.rds_instance_mode}"
  rds_group_type       = "${var.rds_group_type}"
  rds_vcpus            = "${var.rds_vcpus}"
  rds_memory           = "${var.rds_memory}"
  rds_replication_mode = "${var.rds_replication_mode}"
  rds_init_password    = "${var.rds_init_password}"
  rds_volume_type      = "${var.rds_volume_type}"
  rds_volume_size      = "${var.rds_volume_size}"
  rds_backup_starttime = "${var.rds_backup_starttime}"
  rds_backup_keepdays  = "${var.rds_backup_keepdays}"
  time_zone            = "${var.time_zone}"
}


##################### Declaring Module SFS Working #### DONE ###########

module "sfs_turbo" {
  source               = "../modules/sfs_turbo/"
  depends_on           = [module.vpc]
  number_of_azs        = "${var.number_of_azs}"
  availability_zone   = "${var.availability_zone1}"
  availability_zone1  = "${var.availability_zone1}"
  availability_zone2  = "${var.availability_zone2}"
  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  vpc_name             = "${var.vpc_name}"
  subnet_name          = "${var.subnet_name}"
  region               = "${var.region}"
  sfs_turbo_size       = "${var.sfs_turbo_size}"
  sfs_turbo_type       = "${var.sfs_turbo_type}"
  sfs_turbo_enhanced   = "${var.sfs_turbo_enhanced}"
}

##################### Declaring Module DCS Working #### DONE  ###########

module "dcs_redis" {
  source               = "../modules/dcs_redis/"
  depends_on           = [module.vpc]
  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  region               = "${var.region}"
  number_of_azs        = "${var.number_of_azs}"
  availability_zone    = "${var.availability_zone1}"
  availability_zone1   = "${var.availability_zone1}"
  availability_zone2   = "${var.availability_zone2}"
  vpc_name             = "${var.vpc_name}"
  subnet_name          = "${var.subnet_name}"
  dcs_cache_mode       = "${var.dcs_cache_mode}"
  dcs_capacity         = "${var.dcs_capacity}"
  dcs_cpu_architecture = "${var.dcs_cpu_architecture}"
  dcs_type             = "${var.dcs_type}"
  dcs_version          = "${var.dcs_version}"
  dcs_init_password    = "${var.dcs_init_password}"
  dcs_backup_days      = "${var.dcs_backup_days}"
  dcs_backup_starttime = "${var.dcs_backup_starttime}"
  dcs_backup_keepdays  = "${var.dcs_backup_keepdays}"
}

################### Declaring Module ECS Working ###### DONE #########

module "autoscaling" {
  source                = "../modules/autoscaling/"


##########################################################################################
###  Associated Shared ELB - If you use Dedicate ELB module, please comment this block ###
#  depends_on            = [module.image,module.shared_elb]
#  elb_http_pool_id      = "${module.shared_elb.elb_http_pool_id}"        
#  elb_https_pool_id     = "${module.shared_elb.elb_https_pool_id}"      
###########################################################################################

##########################################################################################
###  Associated Dedicated ELB - If you use Shared ELB module, please comment this block ###
  depends_on            = [module.image,module.dedicated_elb]
  elb_http_pool_id      = "${module.dedicated_elb.elb_http_pool_id}"        
  elb_https_pool_id     = "${module.dedicated_elb.elb_https_pool_id}"      
##########################################################################################

  app_name              = "${var.app_name}"
  environment           = "${var.environment}"
  region                = "${var.region}"
  availability_zone     = "${var.availability_zone1}"
  availability_zone1    = "${var.availability_zone1}"
  availability_zone2    = "${var.availability_zone2}"
  vpc_name              = "${var.vpc_name}"
  subnet_name           = "${var.subnet_name}"
  ecs_generation        = "${var.ecs_generation}"
  cpu_core_count        = "${var.cpu_core_count}"
  memory_size           = "${var.memory_size}"
  ecs_sysdisk_size      = "${var.ecs_sysdisk_size}"
  ecs_sysdisk_type      = "${var.ecs_sysdisk_type}"
  desire_instance_number= "${var.desire_instance_number}"
  min_instance_number   = "${var.min_instance_number}"
  max_instance_number   = "${var.max_instance_number}"   
}
