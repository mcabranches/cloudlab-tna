# Log commands to common network control binaries

These scripts are for the purpose of logging common networking utilities on linux.
The utilities that are logged are:

Actual list with paths:
* which trick
  * ipsec
  * netstat
  * arp
  * bridge
  * ifstat
  * ip
  * ipmaddr
  * iptables-apply
  * iptunnel
  * wg
  * tc
* custom solution
  * /sbin/xtables-nft-multi - xtables-nft-multi (arptables*, ebtables*, iptables-nft*, iptables-restore-translate, iptables-translate, xtables-monitor)
  * /sbin/xtables-legacy-multi - xtables-legacy-multi (ip6tables*, iptables* except -apply and those in nft-multi)

Note: there appears to be a lot of commands available through busybox in the container, but I don't have evidence flannel uses those commands (through grepping through the code base).
 
### Setup on flannel-kube pod
On the host, copy the files needed to a directory that is mounted by the pod, in this case:
```bash
kubectl cp /local/repository/flannel_logger_scripts kube-flannel-ds-????:/flannel_logger_scripts -n kube-flannel -c kube-flannel
```

Then, log into the pod (but replace ```kube-flannel-????``` with the actual name of the pod):
```bash
kubectl exec -n kube-flannel -it kube-flannel-ds-hch4g -c kube-flannel -- /bin/bash
```

On the pod/container, run the setup script:
```bash
./install_loggers.sh
```

### Teardown
Remove the loggers (restore to original state), run (on the host or pod):
```bash
./remove_loggers.sh
```

Be sure to clean the log dir (e.g., ```rm -rf /mylogs```) before re-running the install script.

