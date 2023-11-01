#!/bin/bash

OPERATION=/bin/busybox_real/busybox
LOGFILE=/mylogs/busybox.log

# Collect the calling file.
# This is useful because several programs are aliased to busybox
myCallingFile=$(basename "$BASH_SOURCE")
if [[ $myCallingFile == "busybox" ]]; then
  myCallingFile=""
fi

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION $myCallingFile "$@"" >> $LOGFILE
exec $OPERATION $myCallingFile "$@"
