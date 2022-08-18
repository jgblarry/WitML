#!/bin/bash

#############################
##### MONITORING AGENT ######
#############################

wget https://s3-eu-west-1.amazonaws.com/config.nubersia/amazonLinux/installMonitorinAgent.sh
bash installMonitorinAgent.sh


#############################
##### INSTALL OPENVPN  ######
#############################
wget https://s3-eu-west-1.amazonaws.com/config.nubersia/amazonLinux/installOpenVPN.sh
mkdir -p /opt/ManageOpenVPN
cp installOpenVPN.sh /opt/ManageOpenVPN/
bash installOpenVPN.sh