#!/bin/bash

OPERATION=`which ip`_real/ip
LOGFILE=/mylogs/ip.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
