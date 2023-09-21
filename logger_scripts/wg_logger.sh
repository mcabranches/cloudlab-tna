#!/bin/bash

OPERATION=/usr/bin/wg_real/wg
LOGFILE=/mylogs/wg.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
