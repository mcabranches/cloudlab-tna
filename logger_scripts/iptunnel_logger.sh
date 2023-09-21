#!/bin/bash

OPERATION=/usr/sbin/iptunnel_real/iptunnel
LOGFILE=/mylogs/iptunnel.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
