#!/bin/bash

OPERATION=/usr/sbin/route_real/route
LOGFILE=/mylogs/route.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
