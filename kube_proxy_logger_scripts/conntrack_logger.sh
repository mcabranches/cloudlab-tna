#!/bin/sh

OPERATION=/usr/sbin/conntrack_real/conntrack
LOGFILE=/mylogs/conntrack.log

# Log the command line for the operation
echo "$OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
