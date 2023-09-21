#!/bin/bash

set -x
set -e

LOG_DIR="/mylogs"
PROFILE_GROUP="root"
BINS="/usr/sbin/xtables-legacy-multi /usr/sbin/ipset /usr/sbin/ip /usr/sbin/iptables-apply /usr/sbin/ipmaddr /usr/sbin/iptunnel /usr/sbin/ipvsadm /usr/sbin/route /usr/sbin/ethtool /usr/bin/wg /usr/sbin/tc /usr/sbin/ifconfig"

############ General Setup
# Setup log dir for all binaries
 mkdir -p $LOG_DIR

############ Install logger scripts
# Setup logger for every binary we're configured for.
for binarypath in $BINS; do
  bindir=${binarypath%/*}
  #bindir="$(dirname "${binarypath}")"
  binfile="$(basename "${binarypath}")"

  # Only install if in PATH
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, installing logger"
    # copy logger script and make it executable
    cp "$binfile"_logger.sh ./$binfile

    touch "$LOG_DIR/$binfile".log

    # put the original binary in a new directory, replace it with logger script
     mkdir "$binarypath"_real
     cp "$binarypath" "$binarypath"_real/$binfile
     cp -f ./$binfile $binarypath
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
