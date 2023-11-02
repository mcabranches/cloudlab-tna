#!/bin/bash

OPERATION=REPLACE_ME_WITH_BINPATH_real/REPLACE_ME_WITH_BIN
LOGFILE=/mylogs/REPLACE_ME_WITH_BIN.log

# Log the command line for the operation
echo "`date` + `whoami` + $OPERATION "$@"" >> $LOGFILE

# Do the operation
exec $OPERATION "$@"
