################
## OUTPUT VPC ##
################
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

#######################################
## OUTPUT CONFIGURATIONS FILE PACKER ##
#######################################
output "packer" {
  value = data.template_file.packer.rendered
}

#########
## EFS ##
#########

output "efs_dns_name" {
  value = module.efs.efs_dns_name
}
output "efs_id" {
  value = module.efs.efs_id
}

######################
## OPENVPN INSTANCE ##
######################
/*
output "sg_ssh_access" {
  value = "module.openvpn.openvpn_public_ip"
}
*/