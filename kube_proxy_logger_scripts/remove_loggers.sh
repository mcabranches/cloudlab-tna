#!/bin/sh

set -x
set -e

BINS="conntrack ipset iptables-apply ip6tables-apply xtables-legacy-multi xtables-nft-multi"
BINDIR="/usr/sbin"

############ Remove logger scripts
for binfile in $BINS; do
  binpath="$BINDIR/$binfile"

  # Put the original binary back in place (overwriting script),
  ./mycp "$binpath"_real/$binfile "$binpath"

  # Remove extra files
  ./myrm -rf "$binpath"_real
done
