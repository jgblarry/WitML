output "jenkins_id" {
  value = "${module.ec2_cluster.id}"
}

output "nic_id" {
  value = "${module.ec2_cluster.primary_network_interface_id}"
}

