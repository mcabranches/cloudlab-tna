#!/bin/sh

OPERATION=/usr/sbin/ip6tables-apply_real/ip6tables-apply
LOGFILE=/mylogs/ip6tables-apply.log

# Log the command line for the operation
echo "$OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
