#!/bin/bash

set -x
set -e

PROFILE_GROUP="cudevopsfall2018"  #"CUDevOpsFall2018"
LOG_DIR="/mylogs"
BINS="xtables-legacy-multi ipset ip iptables-apply ipmaddr iptunnel ipvsadm route ethtool wg tc ifconfig brctl"
SUDO_STR=""

############ General Setup
# Setup log dir for all binaries
if [ "root" == `whoami` ]; then
  mkdir $LOG_DIR
else
  # If not root, must use sudo as needed (useful for host, not container)
  sudo mkdir $LOG_DIR
  sudo chmod -R 777 $LOG_DIR
  sudo chgrp -R $PROFILE_GROUP $LOG_DIR
  SUDO_STR="sudo"
fi

############ Install logger scripts
# Setup logger for every binary we're configured for.
for binfile in $BINS; do
  # Only install if in PATH
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, installing logger"
    
    binpath=$(readlink -f `which $binfile`)
    bindir=${binpath%/*}

    # copy logger script
    if test -f ./"$binfile"_logger.sh; then
      cp "$binfile"_logger.sh ./$binfile
    else
      # if not specific logger script, use template logger script
      cp template_logger.sh ./$binfile
      sed -i "s/REPLACE_ME_WITH_BIN/$binfile/g" ./$binfile
      escaped_binpath=$(printf '%s\n' "$binpath" | sed -e 's/[\/&]/\\&/g')
      sed -i "s/REPLACE_ME_WITH_BINPATH/$escaped_binpath/g" ./$binfile
    fi

    touch "$LOG_DIR/$binfile".log

    # put the original binary in a new directory, replace it with logger script
    $SUDO_STR mkdir "$binpath"_real
    $SUDO_STR cp "$binpath" "$binpath"_real/$binfile
    $SUDO_STR cp -f ./$binfile $binpath
    rm ./$binfile
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
