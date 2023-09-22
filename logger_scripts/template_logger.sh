#!/bin/bash

OPERATION=REPLACE_WITH_BINPATH_real/REPLACE_WITH_BIN
LOGFILE=/mylogs/REPLACE_WITH_BIN.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
