#!/usr/bin/env bash

#kill -9 $(lsof /var/www/html/upload | awk '{print $2}' | tail -n +3)
umount -f /var/www/html/upload/

if [ $? -eq "0" ];
then
    echo "File system down"
else
    echo "exit 1"
fi

service nginx stop
echo "OK Install script"