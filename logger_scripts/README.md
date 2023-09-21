# Log commands to common network control binaries

These scripts are for the purpose of logging common networking utilities on linux.
The utilities that are logged are:
* ```xtables-legacy-multi```: Other utilities such as ```iptables```, ```ip6tables```, and ```ip6tables-legacy``` are aliases/links of this binary.
* ```ipset```
* ```ip```
* ```iptables-apply```
* ```ipmaddr```
* ```iptunnel```
* ```ipvsadm```
* ```route```
* ```ethtool```
* ```ifconfig```
* ```wg``` (wireguard)
* ```tc``` (traffic control)
 
### Setup on Host
To install the loggers, run:
```bash
./install_loggers_on_host.sh
```

Logs will be placed in the created directory: ```/mylogs```.

### Setup on calico-node pod
On the host, copy the files needed to a directory that is mounted by the pod, in this case:
```bash
sudo cp -r /local/repository/logger_scripts/ /var/log/calico/cni/logger_scripts
```

Then, log into the pod (but replace calico-node-#### with the actual name of the pod):
```bash
kubectl exec -n calico-system -it calico-node-#### -c calico-node -- /bin/bash
```

On the pod/container, run the setup script:
```bash
cd /var/log/calico/cni/logger_scripts
./install_loggers_on_calico_pod.sh
```

Logs will be placed in the created directory: ```/mylogs```.

It was not possible to run the original script inside the pod as the pod is pretty locked down, and
lacks commands like:
* ```tar``` (needed to copy files over to a pod with ```kubectl cp```)
* ```mv```
* ```sudo```
* ```chmod```
* ```dirname```

Also the only user is root, and ```which ip``` gives a different path, so that had to be updated.

### Teardown
Remove the loggers (restore to original state), run (on the host or pod):
```bash
./remove_loggers_on_host.sh
```
OR
```bash
./remove_loggers_on_calico_pod.sh
```

Be sure to clean the log dir (e.g., ```sudo rm -rf /mylogs```) before re-running ```install_loggers.sh```.

### Notes

If the logs aren't informative enough, we could log something about the parent - maybe ust ```$PPID``` but you could also get the parent cmdline with something like:
```
#!/bin/bash

parentCmdline=""
while IFS= read -r -d '' substring || [[ $substring ]]; do
  parentCmdline+="$substring"
done </proc/$PPID/cmdline
echo "$parentCmdline"
```
This solution taken from https://stackoverflow.com/questions/46163678/get-rid-of-warning-command-substitution-ignored-null-byte-in-input
