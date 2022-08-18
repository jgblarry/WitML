#!/usr/bin/env bash
STATUS=`service nginx status | grep Active | awk '{print $3}'`

if [ "${STATUS}" = "(running)" ]
then
    echo "The web service is running"
else
    service nginx start
fi