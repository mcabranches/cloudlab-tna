#!/bin/bash

set -x
set -e

PROFILE_GROUP="CUDevOpsFall2018"
LOG_DIR="/mylogs"
BINS="xtables-legacy-multi ipset ip iptables-apply ipmaddr iptunnel ipvsadm route ethtool wg tc ifconfig brctl bird bird6"

############ General Setup
# Setup log dir for all binaries
if [ "$(id -u)" != "0" ]; then
  mkdir $LOG_DIR
else
  # If not root, must use sudo as needed (useful for host, not container)
  sudo mkdir $LOG_DIR
  sudo chmod -R 777 $LOG_DIR
  sudo chgrp -R $PROFILE_GROUP $LOG_DIR
fi

############ Install logger scripts
# Setup logger for every binary we're configured for.
for binfile in $BINS; do
  # Only install if in PATH
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, installing logger"
    
    binpath=$(readlink -f `which $binfile`)
    bindir=${binpath%/*}

    # copy logger script and make it executable
    cp "$binfile"_logger.sh ./$binfile

    touch "$LOG_DIR/$binfile".log

    # put the original binary in a new directory, replace it with logger script
     mkdir "$binpath"_real
     cp "$binpath" "$binpath"_real/$binfile
     cp -f ./$binfile $binpath
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
