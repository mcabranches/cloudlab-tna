#!/bin/sh

OPERATION=/usr/sbin/iptables-apply_real/iptables-apply
LOGFILE=/mylogs/iptables-apply.log

# Log the command line for the operation
echo "$OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
