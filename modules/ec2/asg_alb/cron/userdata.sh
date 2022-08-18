#!/bin/bash

#############################################
## Aplicar sed al default server del nginx ##
##############################################
service nginx stop
sed -i 's/listen 80 default_server;/listen 80;/g' "/etc/nginx/sites-enabled/default"
sed -i 's/listen \[\:\:\]\:80 default_server;/listen \[\:\:\]\:80;/g' "/etc/nginx/sites-enabled/default"

###############################
## 1- Configuramos el Vhost ##
###############################

aws s3 cp s3://witadvisor-config/prod/api-wit.conf /etc/nginx/conf.d/wit.conf
sed -i 's/APPLICATION/cron/g' "/etc/nginx/conf.d/wit.conf"

sudo apt-get install php-redis -y
aws s3 cp s3://witadvisor-config/prod/php.ini /etc/php/7.2/fpm/php.ini

#################################################
## 5- Colocamos un cron para la monitorizacion ##
#################################################
export EDITOR=/usr/bin/vim.basic
echo "* * * * *  /opt/aws/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --auto-scaling --from-cron" >> /var/spool/cron/crontabs/root

sudo chown root:crontab /var/spool/cron/crontabs/root
chmod 600 /var/spool/cron/crontabs/root


sed -i 's/APPLICATION/cron/g' "/var/awslogs/etc/awslogs.conf"


## AGREGAMOS LAS TAREAS AL CRONTAB ##

sudo mkdir -p /var/log/cronlog
chown -R root:root /var/log/cronlog
aws s3 cp s3://witadvisor-config/prod/crontab /tmp/crontab
cat /tmp/crontab >> /var/spool/cron/crontabs/root
sudo chown root:crontab /var/spool/cron/crontabs/root
chmod 600 /var/spool/cron/crontabs/root

aws s3 cp s3://witadvisor-config/prod/cronlog-awslogs /tmp/cronlog-awslogs
cat /tmp/cronlog-awslogs >> /var/awslogs/etc/awslogs.conf

################################################# 
## 3- Agregamos el endpoint del servicio EFS   ## 
################################################# 
echo "fs-5cb57ba9.efs.us-east-1.amazonaws.com:/witadvisor/production/upload /var/www/html/upload nfs4 defaults 0 0" >> /etc/fstab 
apt-get install -y nfs-common


#6- Reiniciamos servicios

service cron restart
service nginx restart
service awslogs restart
service php7.2-fpm restart

