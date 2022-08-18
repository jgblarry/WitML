############
## GLOBAL ##
############
variable    "region"    {
    description =   "Region de despliegue"
}
variable "project" {
  description = "Nombre del projecto"
}
variable "env" {
  description = "Entorno de trabajo"
}
variable "creator" {
  description = "Creador del stack"
}
variable "terraform" {
  description = "Desplegado con terraform"
}
variable "sg_ssh_access" {
  description = "IP whit ssh access the instance openvpn"
}

#########
## VPC ##
#########
variable "vpc_cidr" {
  type    = string
}
variable  "prefixess_cidr" {
  description = "Prefixess CIDR Subnet"
}
variable "azs" {
  type  = list
}

######################
## OPENVPN INSTANCE ##
######################
variable "openvpn_instance_name" {
  description = "The tag Name for instance OpenVPN"
}
variable "openvpn_instance_type" {
  description = "Size Instance OpenVPN"
}
variable "openvpn_monitoring" {
  description = "Apply monitoring detailed to 1 min"
}
variable "openvpn_associate_public_ip_address" {
  description = "Attach public IP to the instance (true only if not apply Elastic IP)"
}
variable "openvpn_source_dest_check" {
  description =  "Configure in false only where the instance working with VPN service"
}
variable "openvpn_ebs_root_size" {
  description = "Customize details about the root block device of the instance."
}
variable "openvpn_userdata" {
  description = "File Script from configure instance"
}

#############
## EBS-DLM ##
#############
variable "interval" {
  description = "Time between executions"
}
variable "interval_unit" {
  description = "HOURS"
}
variable "times" {
  description = "Execution time"
}
variable "retain_count" {
  description = "Retain time in days"
}

#########################
## AURORA RDS DATABASE ##
#########################

variable "aurora_engine" {
  description = "BBDD engine"
}
variable "version_engine" {
  description = "Version for BBDD engine"
}
variable "replica_count" {
  description = "Write and Read replica number to deploy"
}
variable "instance_type" {
  description = "Type instance to deploy"
}

variable "db_family" {
  description     = "Family Database" #"aurora-mysql5.7"
}
variable "iam_database_authentication_enabled" {
  description = "Use iam autentication"
}
variable "username" {
  description = "Usuario administrador para el RDS"
}
variable "password" {
  description = "Se debe generar un Passwd por cada despliegue"
}
variable "database_name" {
  description = "Database name for default schema"
}

###if you change the accessibility of the data to public,         ###
###you must modify the subnet before they can have public access  ###
variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
}
variable "backup_retention_period" {
  description = "The retention period from RDS snapshot"
}
variable "monitoring_interval" {
  description = "Monitoring interval"
}
variable  "replica_scale_enabled" {
  description = "Configure ASG Read Replica"
}
variable  "replica_scale_cpu" {
  description = "Scaling Condition"
}
variable  "replica_scale_min" {
  description = "Number min replica"
}
variable  "replica_scale_max" {
  description = "Number max replica"
}

##################################
## LAMBDA ALB LOGS API - WORKER ##
##################################
variable "runtime" {
  description = "nodejs10.x"
}
variable  "application_api" {
  description = "Define the application name"
}
variable  "application_admin" {
  description = "Define the application name"
}
variable  "application_cron" {
  description = "Define the application name"
}

######################
## ALB API - WORKER ##
######################
variable "alb_api_internal" {
  description = "false"
}
variable "enable_deletion_protection" {
  description = "false"
}
variable "deregistration_delay" {
  description = "30"
}
variable "idle_timeout" {
  description = "10"
}
variable "access_logs" {
  description = "true"
}

## TARGET GROUP ##
variable "target_group_protocol" {
  description = "HTTP"
}
variable "target_group_port" {
  description = "80"
}
variable "target_group_target_type" {
  description = "instance"
}

## HEALTH CHECK CONFIG ##
variable "hc_protocol" {
  description = "HTTP"
  type    = string
}
variable "hc_path" {
  description = "/health"
  type    = string
}
variable "hc_port" {
  description = "80"
}
variable "healthy_threshold" {
  description = "2"
}
variable "unhealthy_threshold" {
  description = "4"
}
variable "hc_timeout" {
  description = "4"
  type    = string
}
variable "hc_interval" {
  description = "15"
  type    = string
}
variable "hc_matcher" {
  description = "200,301,302"
  type    = string
}

## STICKINESS CONFIG ##
variable "stickiness" {
  description = "false"
}
variable "stickiness_type" {
  description = "lb_cookie"
}
variable "stickiness_cookie_duration" {
  description = "60"
}
variable "stickiness_enabled" {
  description = "false"
}
variable  "certificate_arn" {
  description = "certificate_arn"
}

######################
## ASG API - WORKER ##
######################
variable "max_size" {
  description = "2"
}
variable "min_size" {
  description = "2"
}
variable "desired_capacity" {
  description = "2"
}
variable "health_check_grace_period" {
  description = "300"
}
variable "api_instance_type" {
  description = "t3.medium"
}
variable "admin_instance_type" {
  description = "t3.medium"
}
## Scaling Policy ##
variable "cooldown" {
  description = "120"
}
variable "metric_name" { 
  description = "CPUUtilization"  #MemoryUtilization
}
variable "namespace" {
  description = "AWS/EC2"     #System/Linux
}
variable "statistic" {
  description = "Maximum"     #Average
}
variable "threshold_up" {
  description = "70"
}
variable "threshold_down" {
  description = "30"
}
variable "ebs_root_size" {
  description = "60"
}

##############
## ASG CRON ##
##############
variable "cron_max_size" {
  description = "1"
}
variable "cron_min_size" {
  description = "1"
}
variable "cron_desired_capacity" {
  description = "1"
}
variable "cron_instance_type" {
  description = "t3.micro"
}
variable "cron_ebs_root_size" {
  description = "20"
}

################
## CODEDEPLOY ##
################

variable  "codedeploy_applications" {
  description = "Applications Name"
}
variable  "codedeploy_cron"{
  description = "Applications Name"
}
variable  "codedeploy_env"  {
  description = "Env Codedeploy"
}
variable "compute_platform" {
  description = "Server"
}
variable "deployment_config_name" {
  description = "CodeDeploydescription.OneAtATime"
}
variable "deployment_type" {
  description = "IN_PLACE"
}
variable "deployment_option" {
  description = "WITH_TRAFFIC_CONTROL"
}
variable "deployment_option_cron"{
  description = "WITHOUT_TRAFFIC_CONTROL"
}

#############
## JENKINS ##
#############
variable "jenkins_application" {
  description = "The tag Name for instance Jenkins"
}
variable "jenkins_instance_count" {
  description = "Number of instances for deployment"
}
variable "jenkins_instance_type" {
  description = "Instance Type from the Jenkins"
}
variable "jenkins_monitoring" {
  description = "Apply monitoring detailed to 1 min"
}
variable "jenkins_ebs_root_size" {
  description = "Customize details about the root block device of the instance."
}
variable "jenkins_userdata" {
  description = "File Script from configure instance"
}

variable "jenkins_hc_path" {
  description = "/"
  type    = string
}

###########
## REDIS ##
###########
variable "redis_pg_family" {
  description = "redis5.0"
}
variable "redis_cluster_id" {
  description = "redis"
}
variable "redis_engine" {
  description = "redis"
}
variable "redis_node_type" {
  description = "cache.t2.small"
}
variable "redis_num_cache_nodes" {
  description = "1"
}
variable "redis_engine_version" {
  description = "5.0.4"
}
variable "redis_port" {
  description = "6379"
}

#########
## EFS ##
#########
