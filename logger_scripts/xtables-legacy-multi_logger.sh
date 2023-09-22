#!/bin/bash

OPERATION=/usr/sbin/xtables-legacy-multi_real/xtables-legacy-multi
LOGFILE=/mylogs/xtables-legacy-multi.log

# Collect the calling file.
# This is useful because several programs are aliased to xtables-legacy-multi
myCallingFile=$(basename "$BASH_SOURCE")
if [[ $myCallingFile == "xtables-legacy-multi" ]]; then
  myCallingFile=""
fi

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION $myCallingFile "$@"" >> $LOGFILE

if [[ $myCallingFile == "iptables-legacy-restore" ]]; then
  rm -f mystdin.txt
  cat > mystdin.txt
  cat mystdin.txt >> $LOGFILE

  # Do the operation
  exec cat mystdin.txt | $OPERATION $myCallingFile "$@"
else
  exec $OPERATION $myCallingFile "$@"
fi
