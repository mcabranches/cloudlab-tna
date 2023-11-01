#!/bin/sh

OPERATION=/usr/sbin/ipset_real/ipset
LOGFILE=/mylogs/ipset.log

# Log the command line for the operation
echo "$OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
