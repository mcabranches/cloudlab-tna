#!/bin/sh

OPERATION=/usr/sbin/xtables-nft-multi_real/xtables-nft-multi
LOGFILE=/mylogs/xtables-nft-multi.log

# Collect the calling file.
# This is useful because several programs are aliased to xtables-nft-multi
myCallingFile=$(/lib/modules/kube_proxy_logger_scripts/mybasename "$0")
if [ "$myCallingFile" = "xtables-nft-multi" ]; then
  myCallingFile=""
fi

# Log the command line for the operation
echo "$OPERATION $myCallingFile "$@"" >> $LOGFILE

case "$myCallingFile" in
    *"-restore") tmpFile=$(/lib/modules/kube_proxy_logger_scripts/mymktemp); cat > $tmpFile ; cat $tmpFile >> $LOGFILE ; exec cat $tmpFile | $OPERATION $myCallingFile "$@" ;;
    *) exec $OPERATION $myCallingFile "$@" ;;
esac
