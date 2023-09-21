#!/bin/bash

OPERATION=/usr/sbin/ethtool_real/ethtool
LOGFILE=/mylogs/ethtool.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
