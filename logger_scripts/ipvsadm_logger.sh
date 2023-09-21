#!/bin/bash

OPERATION=/usr/sbin/ipvsadm_real/ipvsadm
LOGFILE=/mylogs/ipvsadm.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
