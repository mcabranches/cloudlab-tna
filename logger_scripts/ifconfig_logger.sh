#!/bin/bash

OPERATION=/usr/sbin/ifconfig_real/ifconfig
LOGFILE=/mylogs/ifconfig.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
