#!/bin/bash

OPERATION=/usr/sbin/ipmaddr_real/ipmaddr
LOGFILE=/mylogs/ipmaddr.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
