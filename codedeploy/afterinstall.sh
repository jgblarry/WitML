#!/usr/bin/env bash

mount -a

VALIDATE=$(mount | grep upload | wc -l)

if [ $VALIDATE -eq "1" ];
then
    echo "The EFS system is mount"
else
    echo "exit 1"
fi

service nginx restart
service php7.2-fpm restart