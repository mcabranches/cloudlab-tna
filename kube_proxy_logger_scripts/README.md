# Log commands to common network control binaries

These scripts are for the purpose of logging common networking utilities on linux.
The utilities that are logged are:
* ```xtables-legacy-multi```: Other utilities such as ```iptables```, ```ip6tables```, and ```ip6tables-legacy``` are aliases/links of this binary.
* ```xtables-nft-multi```: Other utilities such as ```arptables-nft``` are aliases/links of this binary.
* ```ipset```
* ```conntrack```
* ```iptables-apply```
 
### Setup on kube-proxy pod
On the host, copy the files needed to a directory that is mounted by the pod, in this case:
```bash
cd /local/repository/kube_proxy_logger_scripts/
make
sudo cp -r /local/repository/kube_proxy_logger_scripts/ /lib/modules/kube_proxy_logger_scripts
```

Then, log into the pod (but replace ```kube-proxy-????``` with the actual name of the pod):
```bash
kubectl exec -n kube-system --stdin --tty kube-proxy-???? -- /bin/sh
```

On the pod/container, run the setup script:
```bash
cd /lib/modules/kube_proxy_logger_scripts
./install_loggers.sh
```

### Teardown
Remove the loggers (restore to original state):
```bash
./remove_loggers.sh
```

Be sure to clean the log dir (e.g., ```./myrm -rf /mylogs```) before re-running either install script.

