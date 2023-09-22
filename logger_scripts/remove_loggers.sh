#!/bin/bash

set -x
set -e

BINS="xtables-legacy-multi ipset ip iptables-apply ipmaddr iptunnel ipvsadm route ethtool wg tc ifconfig brctl"
SUDO_STR=""

if [ "root" != `whoami` ]; then
  SUDO_STR="sudo"
fi

############ Remove logger scripts
for binfile in $BINS; do
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, removing logger"

    binpath=$(readlink -f `which $binfile`)
    bindir=${binpath%/*}

    # Put the original binary back in place (overwriting script),
    # Remove created _real directory
    $SUDO_STR cp -f "$binpath"_real/$binfile "$binpath"
    $SUDO_STR rm -rf "$binpath"_real
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
