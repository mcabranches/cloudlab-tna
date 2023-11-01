#!/bin/sh

OPERATION=/usr/sbin/xtables-legacy-multi_real/xtables-legacy-multi
LOGFILE=/mylogs/xtables-legacy-multi.log

# Collect the calling file.
# This is useful because several programs are aliased to xtables-legacy-multi
myCallingFile=$(/lib/modules/kube_proxy_logger_scripts/mybasename "$0")
if [ "$myCallingFile" = "xtables-legacy-multi" ]; then
  myCallingFile=""
fi

# Log the command line for the operation
echo "$OPERATION $myCallingFile "$@"" >> $LOGFILE

case "$myCallingFile" in
    *"-restore") tmpFile=$(/lib/modules/kube_proxy_logger_scripts/mymktemp); cat > $tmpFile ; cat $tmpFile >> $LOGFILE ; exec cat $tmpFile | $OPERATION $myCallingFile "$@" ;;
    *) exec $OPERATION $myCallingFile "$@" ;;
esac
