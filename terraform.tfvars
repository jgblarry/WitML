## GLOBAL
region                                  =   "us-east-1"
project                                 =   "witadvisor"
env                                     =   "production"
creator                                 =   "reinaldoleon"
terraform                               =   "true"
sg_ssh_access                           =   "54.167.213.223/32" # Se crea al disponer de la Public IP de la instancia OpenVPN

## VPC
vpc_cidr                                =   "172.16.0.0/16"
prefixess_cidr                          =   "172.16"
azs                                     =   ["Aza", "Azb", "Azc", "Azd", "Aze", "Azf"]

## OPENVPN INSTANCE
openvpn_instance_name                   =   "OpenVPN"
openvpn_instance_type                   =   "t3.small"
openvpn_monitoring                      =   "true"
openvpn_associate_public_ip_address     =   "true"
openvpn_source_dest_check               =   "false"
openvpn_ebs_root_size                   =   "20"
openvpn_userdata                        =   "./modules/ec2/openvpn/userdata_openvpn_amz.tpl"

## EBS-DLM
interval                                =   "24"
interval_unit                           =   "HOURS"
times                                   =   "00:30"
retain_count                            =   "10"

## AURORA MYSQL
aurora_engine                           =   "aurora"
version_engine                          =   "5.6.mysql_aurora.1.22.2"
replica_count                           =   "2"
instance_type                           =   "db.t3.small"
db_family                               =   "aurora5.6"
database_name                           =   "witadvisor" 
publicly_accessible                     =   "false"
backup_retention_period                 =   "10"
monitoring_interval                     =   "60"
iam_database_authentication_enabled     =   "false"
replica_scale_enabled                   =   true
replica_scale_cpu                       =   "60"
replica_scale_min                       =   "1"
replica_scale_max                       =   "5"

## LAMBDA ALB LOGS API - WORKET
application_api                         =   "api"
application_admin                       =   "admin"
application_cron                        =   "cron"
runtime                                 =   "nodejs10.x"

## ALB API - ADMIN
certificate_arn                         =   "arn:aws:acm:us-east-1:616011984029:certificate/4e810288-b48d-4e2d-b259-9f4c6cb093e0"
alb_api_internal                        =   "false"
enable_deletion_protection              =   "false"
deregistration_delay                    =   "15"
idle_timeout                            =   "30"
access_logs                             =   "true"
target_group_protocol                   =   "HTTP"
target_group_port                       =   "80"
target_group_target_type                =   "instance"
hc_protocol                             =   "HTTP"
hc_path                                 =   "/ping.php"
hc_port                                 =   "80"
healthy_threshold                       =   "2"
unhealthy_threshold                     =   "4"
hc_timeout                              =   "4"
hc_interval                             =   "15"
hc_matcher                              =   "200,301,302"
stickiness                              =   "false"
stickiness_type                         =   "lb_cookie"
stickiness_cookie_duration              =   "60"
stickiness_enabled                      =   "false"

## ASG API - ADMIN
max_size                                =   "10"
min_size                                =   "2"
desired_capacity                        =   "2"
health_check_grace_period               =   "120"
api_instance_type                       =   "t3.micro"
admin_instance_type                     =   "t3.micro"
cooldown                                =   "180"
metric_name                             =   "CPUUtilization"
namespace                               =   "AWS/EC2"
statistic                               =   "Maximum"
threshold_up                            =   "70"
threshold_down                          =   "30"
ebs_root_size                           =   "30"


## ASG CRON
cron_max_size                           =   "1"
cron_min_size                           =   "1"
cron_desired_capacity                   =   "1"
cron_instance_type                      =   "t3.micro"
cron_ebs_root_size                      =   "20"

## CODEDEPLOY
codedeploy_applications                 =   ["Api", "Admin"]
codedeploy_cron                         =   "Cron" 
codedeploy_env                          =   ["production"]
compute_platform                        =   "Server"
deployment_config_name                  =   "CodeDeployDefault.OneAtATime"
deployment_type                         =   "IN_PLACE"
deployment_option                       =   "WITH_TRAFFIC_CONTROL"
deployment_option_cron                  =   "WITHOUT_TRAFFIC_CONTROL"                    

## JENKINS
jenkins_instance_type                   =   "t3.small"
jenkins_application                     =   "Jenkins"
jenkins_userdata                        =   "userdata_jenkins_amz.tpl"
jenkins_ebs_root_size                   =   "30"
jenkins_instance_count                  =   "1"
jenkins_monitoring                      =   true
jenkins_hc_path                         =   "/login"

## REDIS
redis_pg_family                         =   "redis5.0"
redis_cluster_id                        =   "redis"
redis_engine                            =   "redis"
redis_node_type                         =   "cache.t3.small"
redis_num_cache_nodes                   =   "1"
redis_engine_version                    =   "5.0.4"
redis_port                              =   "6379"
