#!/bin/bash

##################################
## INSTALACION UBUNTU 18.04 LTS ##
##    AMI WitAdvisor APP v1.0   ##
##################################
sleep 60
##############################
## HERRAMIENTAS ADICIONALES ##
##############################
echo -e "INSTALANDO PAQUETES ADICIONALES... \n"
sudo apt-get install -y zip unzip 

## SYSTEM UPDATE 
echo -e "ACTUALIZANDO EL SISTEMA... \n"
sudo apt-get update -y
sudo apt  install awscli -y
sleep 5
#########################
## INSTALACION PHP 7.2 ##
#########################
echo -e "INSTALANDO PAQUETES PHP ... \n"
###PHP 72
sudo apt-get install -y php7.2-cli php7.2-common php7.2-curl php7.2-fpm php7.2-gd php7.2-imap php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-xml php7.2-xsl php7.2-zip
sleep 5

#######################
## INSTALACION NGINX ##
#######################
echo -e "INSTALANDO NGINX... \n"
sudo apt-get install -y nginx

##################
## MEMORIA SWAP	##
##################
echo -e "AGREGANDO MEMORIA SWAP.. \n"
sudo dd if=/dev/zero of=/swapfile bs=512M count=4
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s
sudo echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

sudo echo "Check Swap"
sudo grep Swap /proc/meminfo
sudo cat /proc/swaps
sudo sleep 5

#####################################
## INSTALACION DE PYTHON           ##
#####################################
echo -e "INSTALANDO PYTHON... \n"
#sudo apt-get remove --purge python3 -y
#sudo apt autoremove -y
sudo apt-get install python2.7 -y  # libyaml-dev python-dev
sleep 5

#####################################
## INSTALACION DE HERRAMIENTAS AWS ##
#####################################
echo -e "CONFIGURANDO HERRAMIENTAS AWS LOGS... \n"
REGION=us-east-1 ##$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep -oP '\"region\" : \"\K[^\"]+')
cd /tmp/
sudo curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo chmod +x ./awslogs-agent-setup.py
python2.7 awslogs-agent-setup.py -n -r ${REGION} -c /home/ubuntu/awslogs.conf
sudo update-rc.d awslogs defaults

sudo sleep 5

#############################
##### MONITORING AGENT ######
#############################
echo -e "CONFIGURANDO HERRAMIENTAS AWS MONITORING... \n"
sudo apt-get -y install unzip
sudo apt-get -y install libwww-perl libdatetime-perl
sudo mkdir /opt/aws
sudo chmod +x /opt/aws
cd /opt/aws/
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \
cd aws-scripts-mon
sudo sleep 5
#sudo echo "* * * * *  /opt/aws/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --auto-scaling --from-cron" >> ${CRONTAB}


##############################
## INSTALL CODEDEPLOY AGENT ##
##############################
echo -e "INSTALANDO AGENTE DE CODEDEPLOY... \n"
cd /tmp/
sudo apt-get install ruby -y
sudo apt-get install wget
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install 
sudo chmod +x ./install
./install auto

##################
## END SERVICES ##
##################
sudo rm -rf /var/www/*
sudo mkdir -p /var/www/html
echo -e "FINALIZANDO LA IMAGEN... \n"


