#!/bin/bash

set -x
set -e

LOG_DIR="/mylogs"
PROFILE_GROUP="cudevopsfall2018"
BINS="/usr/sbin/xtables-legacy-multi /usr/sbin/ipset /bin/ip /usr/sbin/iptables-apply /usr/sbin/ipmaddr /usr/sbin/iptunnel /usr/sbin/ipvsadm /usr/sbin/route /usr/sbin/ethtool /usr/bin/wg"

############ General Setup
# Setup log dir for all binaries
sudo mkdir $LOG_DIR
sudo chgrp $PROFILE_GROUP $LOG_DIR
sudo chmod -R 777 $LOG_DIR

############ Install logger scripts
# Setup logger for every binary we're configured for.
for binarypath in $BINS; do
  bindir="$(dirname "${binarypath}")"
  binfile="$(basename "${binarypath}")"

  # Only install if in PATH
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, installing logger"
    # copy logger script and make it executable
    cp "$binfile"_logger.sh ./$binfile
    chmod +x ./$binfile

    touch "$LOG_DIR/$binfile".log
    chmod 777 "$LOG_DIR/$binfile".log

    # put the original binary in a new directory, replace it with logger script
    sudo mkdir "$binarypath"_real
    sudo mv "$binarypath" "$binarypath"_real/$binfile
    sudo mv ./$binfile $binarypath
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
