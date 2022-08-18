#!/bin/bash

echo "Validate"
mount -a

VALIDATE=$(mount | grep upload | wc -l)

if [ $VALIDATE -eq "1" ];
then
    echo "The EFS system is mount"
else
    exit 1
fi