#!/bin/bash

set -x
set -e

BINS="xtables-nft-multi xtables-legacy-multi busybox ipsec netstat arp bridge ifstat ip ipmaddr iptables-apply iptables-wrapper iptunnel routel wg tc"

############ Remove logger scripts
for binfile in $BINS; do
  if [[ $(type -P "$binfile") ]]; then
    echo "$binfile is in PATH, removing logger"

    binpath=$(readlink -f `which $binfile`)
    bindir=${binpath%/*}

    # Put the original binary back in place (overwriting script),
    # Remove created _real directory
    cp -f "$binpath"_real/$binfile "$binpath"
    rm -rf "$binpath"_real
  else
    echo "$binfile is NOT in PATH, ignoring" 1>&2
  fi
done
