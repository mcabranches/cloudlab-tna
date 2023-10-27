#!/bin/sh

set -x
set -e

LOG_DIR="/mylogs"

BINS="conntrack ipset iptables-apply ip6tables-apply xtables-legacy-multi xtables-nft-multi"
BINPATH="/usr/sbin"

# Create the log directory
./mymkdir $LOG_DIR

# Setup logger for every binary we're configured for.
for bin in $BINS; do

  binpath="$BINPATH/$bin"

  # Create a log file for the binary
  ./mytouch "$LOG_DIR/$bin".log

  # put the original binary in a new directory, replace it with logger script
  ./mymkdir "$binpath"_real
  ./mycp "$binpath" "$binpath"_real/$bin
  ./mycp "$bin"_logger.sh $binpath
done
