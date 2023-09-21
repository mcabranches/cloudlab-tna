#!/bin/bash

OPERATION=/usr/sbin/tc_real/tc
LOGFILE=/mylogs/tc.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
