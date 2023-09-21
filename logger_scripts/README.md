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
 
### Dependencies

These scripts were created with the paths for binaries in the default setup of Ubuntu 20.04.
It also assumes ```ipset``` and ```ipvsadm``` are installed with something like the following:
```bash
sudo apt install -y ipset ipvsadm
``` 

### Setup
To install the loggers, run:
```bash
./install_loggers.sh
```

Logs will be placed in the created directory: ```/mylogs```.

### Teardown
Remove the loggers (restore to original state), run:
```bash
./remove_loggers.sh
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
