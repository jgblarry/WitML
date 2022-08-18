#!/bin/bash

############################
##### JENKINS INSTALL ######
############################

wget https://s3-eu-west-1.amazonaws.com/config.nubersia/amazonLinux/installJenkins.sh
bash installJenkins.sh

#############################
##### MONITORING AGENT ######
#############################

wget https://s3-eu-west-1.amazonaws.com/config.nubersia/amazonLinux/installMonitorinAgent.sh
bash installMonitorinAgent.sh


#########################
## KEY GENERATE CLIENT ##
#########################
wget https://s3-eu-west-1.amazonaws.com/config.nubersia/amazonLinux/installKeyGenerator.sh
mkdir -p /opt/KeyGenerator
mv installKeyGenerator.sh /opt/KeyGenerator
bash /opt/KeyGenerator/installKeyGenerator.sh WitAdvisor
