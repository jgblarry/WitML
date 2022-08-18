output "openvpn_id" {
  value = "${module.ec2_cluster.id}"
}
output "openvpn_public_ip" {
  value = "${aws_eip.eip_openvpn.id}"
}

output "nic_id" {
  value = "${module.ec2_cluster.primary_network_interface_id}"
}

