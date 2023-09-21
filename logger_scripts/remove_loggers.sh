#!/bin/bash

set -x
set -e

BINS="/usr/sbin/xtables-legacy-multi /usr/sbin/ipset /bin/ip /usr/sbin/iptables-apply /usr/sbin/ipmaddr /usr/sbin/iptunnel /usr/sbin/ipvsadm /usr/sbin/route /usr/sbin/ethtool /usr/bin/wg /usr/sbin/tc /usr/sbin/ifconfig"

############ Remove logger scripts
for binarypath in $BINS; do
  bindir="$(dirname "${binarypath}")"
  binfile="$(basename "${binarypath}")"

  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, removing logger"
    # Put the original binary back in place (overwriting script),
    # Remove created _real directory
    sudo mv "$binarypath"_real/$binfile "$binarypath"
    sudo rmdir "$binarypath"_real
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
