#!/bin/bash

set -x
set -e

LOG_DIR="/mylogs"
BINS="xtables-nft-multi xtables-legacy-multi busybox ipsec netstat arp bridge ifstat ip ipmaddr iptables-apply iptables-wrapper iptunnel routel wg tc"

mkdir $LOG_DIR

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
      escaped_binpath=$(printf '%s\n' "$binpath" | sed -e 's/[\/&]/\\&/g')
      sed -i "s/REPLACE_ME_WITH_BINPATH/$escaped_binpath/g" ./$binfile
      sed -i "s/REPLACE_ME_WITH_BIN/$binfile/g" ./$binfile
    fi

    touch "$LOG_DIR/$binfile".log

    # put the original binary in a new directory, replace it with logger script
    mkdir "$binpath"_real
    cp "$binpath" "$binpath"_real/$binfile
    cp -f ./$binfile $binpath
    rm ./$binfile
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
