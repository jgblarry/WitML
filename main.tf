################
## MODULE VPC ##
################

module "vpc" {
    source                                  =   "./modules/vpc"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    vpc_cidr                                =   var.vpc_cidr 
    prefixess_cidr                          =   var.prefixess_cidr
    azs                                     =   var.azs
}   

module "openvpn"    {
    source                                  =   "./modules/ec2/openvpn"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    openvpn_instance_name                   =   var.openvpn_instance_name
    openvpn_instance_type                   =   var.openvpn_instance_type
    openvpn_monitoring                      =   var.openvpn_monitoring
    openvpn_associate_public_ip_address     =   var.openvpn_associate_public_ip_address
    openvpn_source_dest_check               =   var.openvpn_source_dest_check
    openvpn_ebs_root_size                   =   var.openvpn_ebs_root_size
    openvpn_userdata                        =   var.openvpn_userdata
    #
    vpc_id                                  =   module.vpc.vpc_id
    public_subnet_ids                       =   module.vpc.public_subnet_ids
}

module "ebs-dlm"    {
    source                                  =   "./modules/ebs_dlm"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    interval                                =   var.interval
    interval_unit                           =   var.interval_unit
    times                                   =   var.times
    retain_count                            =   var.retain_count
}

module "aurora-mysql"   {
    source                                  =   "./modules/aurora-mysql"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    aurora_engine                           =   var.aurora_engine
    version_engine                          =   var.version_engine
    replica_count                           =   var.replica_count               
    instance_type                           =   var.instance_type
    db_family                               =   var.db_family 
    username                                =   var.username
    password                                =   var.password
    database_name                           =   var.database_name
    publicly_accessible                     =   var.publicly_accessible
    backup_retention_period                 =   var.backup_retention_period
    monitoring_interval                     =   var.monitoring_interval
    iam_database_authentication_enabled     =   var.iam_database_authentication_enabled
    replica_scale_enabled                   =   var.replica_scale_enabled
    replica_scale_min                       =   var.replica_scale_min
    replica_scale_max                       =   var.replica_scale_max
    replica_scale_cpu                       =   var.replica_scale_cpu
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    database_subnet_ids                     =   module.vpc.database_subnet_ids
}

module "alb_logs_api"   {
    source                                  =   "./modules/lambda/alb_logs_api"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    application                             =   var.application_api
    runtime                                 =   var.runtime
}

module "alb_logs_admin"   {
    source                                  =   "./modules/lambda/alb_logs_admin"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    application                             =   var.application_admin
    runtime                                 =   var.runtime
}

module "alb_api" {
    source                                  = "./modules/ec2/alb/api"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    application                             =   var.application_api
    #
    internal                                =   var.alb_api_internal
    enable_deletion_protection              =   var.enable_deletion_protection
    deregistration_delay                    =   var.deregistration_delay
    idle_timeout                            =   var.idle_timeout
    access_logs                             =   var.access_logs
    target_group_protocol                   =   var.target_group_protocol 
    target_group_port                       =   var.target_group_port  
    target_group_target_type                =   var.target_group_target_type
    hc_protocol                             =   var.hc_protocol
    hc_path                                 =   var.hc_path 
    hc_port                                 =   var.hc_port
    healthy_threshold                       =   var.healthy_threshold
    unhealthy_threshold                     =   var.unhealthy_threshold
    hc_timeout                              =   var.hc_timeout
    hc_interval                             =   var.hc_interval
    hc_matcher                              =   var.hc_matcher
    stickiness                              =   var.stickiness
    stickiness_type                         =   var.stickiness_type
    stickiness_cookie_duration              =   var.stickiness_cookie_duration
    stickiness_enabled                      =   var.stickiness_enabled
    #
    vpc_id                                  =   module.vpc.vpc_id
    public_subnet_ids                       =   module.vpc.public_subnet_ids
    api_lambda_arn                          =   module.alb_logs_api.lambda_arn
    api_lambda_name                         =   module.alb_logs_api.lambda_name
    certificate_arn                         =   "arn:aws:acm:us-east-1:616011984029:certificate/4e810288-b48d-4e2d-b259-9f4c6cb093e0"
}

module "alb_admin" {
    source                                  = "./modules/ec2/alb/admin"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    application                             =   var.application_admin
    #
    internal                                =   var.alb_api_internal
    enable_deletion_protection              =   var.enable_deletion_protection
    deregistration_delay                    =   var.deregistration_delay
    idle_timeout                            =   var.idle_timeout
    access_logs                             =   var.access_logs
    target_group_protocol                   =   var.target_group_protocol 
    target_group_port                       =   var.target_group_port  
    target_group_target_type                =   var.target_group_target_type
    hc_protocol                             =   var.hc_protocol
    hc_path                                 =   var.hc_path 
    hc_port                                 =   var.hc_port
    healthy_threshold                       =   var.healthy_threshold
    unhealthy_threshold                     =   var.unhealthy_threshold
    hc_timeout                              =   var.hc_timeout
    hc_interval                             =   var.hc_interval
    hc_matcher                              =   var.hc_matcher
    stickiness                              =   var.stickiness
    stickiness_type                         =   var.stickiness_type
    stickiness_cookie_duration              =   var.stickiness_cookie_duration
    stickiness_enabled                      =   var.stickiness_enabled
    #
    vpc_id                                  =   module.vpc.vpc_id
    public_subnet_ids                       =   module.vpc.public_subnet_ids
    admin_lambda_arn                       =   module.alb_logs_admin.lambda_arn
    admin_lambda_name                      =   module.alb_logs_admin.lambda_name
    certificate_arn                         =   "arn:aws:acm:us-east-1:616011984029:certificate/4e810288-b48d-4e2d-b259-9f4c6cb093e0"
}
module "asg_api" {
    source                                  = "./modules/ec2/asg_alb/api"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    application                             =   var.application_api
    max_size                                =   var.max_size
    min_size                                =   var.min_size
    desired_capacity                        =   var.desired_capacity
    health_check_grace_period               =   var.health_check_grace_period
    api_instance_type                       =   var.api_instance_type 
    cooldown                                =   var.cooldown
    metric_name                             =   var.metric_name
    namespace                               =   var.namespace
    statistic                               =   var.statistic
    threshold_up                            =   var.threshold_up
    threshold_down                          =   var.threshold_down
    ebs_root_size                           =   var.ebs_root_size
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    private_subnet_ids                      =   module.vpc.private_subnet_ids
    sg_alb                                  =   module.alb_api.sg_alb
    aws_lb_target_group                     =   module.alb_api.aws_lb_target_group
}

module "asg_admin" {
    source                                  = "./modules/ec2/asg_alb/admin"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    application                             =   var.application_admin
    max_size                                =   var.max_size
    min_size                                =   var.min_size
    desired_capacity                        =   var.desired_capacity
    health_check_grace_period               =   var.health_check_grace_period
    admin_instance_type                     =   var.admin_instance_type 
    cooldown                                =   var.cooldown
    metric_name                             =   var.metric_name
    namespace                               =   var.namespace
    statistic                               =   var.statistic
    threshold_up                            =   var.threshold_up
    threshold_down                          =   var.threshold_down
    ebs_root_size                           =   var.ebs_root_size
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    private_subnet_ids                      =   module.vpc.private_subnet_ids
    sg_alb                                  =   module.alb_admin.sg_alb
    sg_internal_ssh                         =   module.asg_api.sg_internal_ssh
    aws_lb_target_group                     =   module.alb_admin.aws_lb_target_group
}

module "asg_cron" {
    source                                  = "./modules/ec2/asg_alb/cron"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    application                             =   var.application_cron
    cron_max_size                           =   var.cron_max_size
    cron_min_size                           =   var.cron_min_size
    cron_desired_capacity                   =   var.cron_desired_capacity
    health_check_grace_period               =   var.health_check_grace_period
    cron_instance_type                      =   var.cron_instance_type 
    cron_ebs_root_size                      =   var.cron_ebs_root_size
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    private_subnet_ids                      =   module.vpc.private_subnet_ids
    sg_internal_ssh                         =   module.asg_api.sg_internal_ssh

}

module "codedeploy" {
    source                                  = "./modules/codedeploy"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    codedeploy_applications                 =   var.codedeploy_applications
    codedeploy_cron                         =   var.codedeploy_cron
    codedeploy_env                          =   var.codedeploy_env
    compute_platform                        =   var.compute_platform
    deployment_config_name                  =   var.deployment_config_name
    deployment_type                         =   var.deployment_type
    deployment_option                       =   var.deployment_option
    deployment_option_cron                  =   var.deployment_option_cron
    #
    autoscaling_groups                      =   [module.asg_api.this_autoscaling_group_id, module.asg_admin.this_autoscaling_group_id, module.asg_cron.this_autoscaling_group_id]   
    albs                                    =   [module.alb_api.aws_alb_target_group_name, module.alb_admin.aws_alb_target_group_name, "false"]
}

module "bucket-config" {
    source                                  = "./modules/bucket-config"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
}

module "jenkins"    {
    source                                  = "./modules/ec2/jenkins"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    #
    jenkins_application                     =   var.jenkins_application
    jenkins_instance_type                   =   var.jenkins_instance_type
    jenkins_instance_count                  =   var.jenkins_instance_count
    jenkins_monitoring                      =   var.jenkins_monitoring
    jenkins_userdata                        =   var.jenkins_userdata
    jenkins_ebs_root_size                   =   var.jenkins_ebs_root_size
    #
    target_group_protocol                   =   var.target_group_protocol 
    target_group_port                       =   var.target_group_port  
    target_group_target_type                =   var.target_group_target_type
    hc_protocol                             =   var.hc_protocol
    jenkins_hc_path                         =   var.jenkins_hc_path 
    hc_port                                 =   var.hc_port 
    healthy_threshold                       =   var.healthy_threshold
    unhealthy_threshold                     =   var.unhealthy_threshold
    hc_timeout                              =   var.hc_timeout
    hc_interval                             =   var.hc_interval
    hc_matcher                              =   var.hc_matcher
    stickiness                              =   var.stickiness
    stickiness_type                         =   var.stickiness_type
    stickiness_cookie_duration              =   var.stickiness_cookie_duration
    stickiness_enabled                      =   var.stickiness_enabled
    deregistration_delay                    =   var.deregistration_delay
    #
    sg_jenkins                              =   module.asg_api.sg_api_app
    sg_internal_ssh                         =   module.asg_api.sg_internal_ssh
    private_subnet_ids                      =   module.vpc.private_subnet_ids
    api_listener_ssl                        =   module.alb_api.listener_ssl
    vpc_id                                  =   module.vpc.vpc_id
}

module "redis" {
    source                                  = "./modules/redis"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    #
    redis_pg_family                         =   var.redis_pg_family
    redis_cluster_id                        =   var.redis_cluster_id
    redis_engine                            =   var.redis_engine
    redis_node_type                         =   var.redis_node_type
    redis_num_cache_nodes                   =   var.redis_num_cache_nodes
    redis_engine_version                    =   var.redis_engine_version
    redis_port                              =   var.redis_port
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    private_subnet_ids                      =   module.vpc.private_subnet_ids    
}

module "efs" {
    source                                  = "./modules/efs"
    region                                  =   var.region
    project                                 =   var.project
    env                                     =   var.env
    creator                                 =   var.creator
    terraform                               =   var.terraform
    #
    vpc_id                                  =   module.vpc.vpc_id
    vpc_cidr                                =   module.vpc.vpc_cidr
    private_subnet_ids                      =   module.vpc.private_subnet_ids
}