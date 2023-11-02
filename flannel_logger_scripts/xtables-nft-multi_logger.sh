#!/bin/bash

OPERATION=/sbin/xtables-nft-multi_real/xtables-nft-multi
LOGFILE=/mylogs/xtables-nft-multi.log

# Collect the calling file.
# This is useful because several programs are aliased to xtables-nft-multi
myCallingFile=$(basename "$BASH_SOURCE")
if [[ $myCallingFile == "xtables-nft-multi" ]]; then
  myCallingFile=""
fi

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION $myCallingFile "$@"" >> $LOGFILE

if [[ $myCallingFile == "iptables-nft-restore" ]]; then
  rm -f mystdin.txt
  cat > mystdin.txt
  cat mystdin.txt >> $LOGFILE

  # Do the operation
  exec cat mystdin.txt | $OPERATION $myCallingFile "$@"
else
  exec $OPERATION $myCallingFile "$@"
fi
