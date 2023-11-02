#!/bin/bash

# direct binary checks
ipsec --version
arp --version
netstat --version
bridge help
ifstat -v
ip help
ipmaddr --version
iptables-apply --version
iptunnel --version
wg --version
tc -help

# xtables checks
xtables-nft-multi
xtables-legacy-multi
iptables --version
iptables-nft --version
