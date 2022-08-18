#!/usr/bin/env bash

STATUS=`service nginx status | grep Active | awk '{print $3}'`

if [ "${STATUS}" = "(dead)" ]
then
    echo "The web service is not running"
else
    service nginx stop
fi