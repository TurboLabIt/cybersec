## zzalias

```shell
sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/zzalias/master/setup.sh | sudo bash ; source /usr/local/bin/zzalias
```


## port scan

`zznmap <target>` ([source](https://github.com/TurboLabIt/zzalias/blob/master/zzalias.sh))

```shell
sudo nmap -sS -Pn -A -p- -v <target>
```

- `-sS`: TCP SYN scan
- `-Pn`: No ping
- `-A`: Aggressive scan options (OS, ...)
- `-p-`: All TCP ports
- `-v`: Verbose (Open ports are shown as they are found and completion time estimates are provided)


## vuln scan

Scan a target  for all vulnerabilities in the default script library for the vuln category

`zzvuln <target>` ([source](https://github.com/TurboLabIt/zzalias/blob/master/zzalias.sh))

```shell
sudo nmap --script vuln -v
```

📝 Certain scans attempt to verify a vulnerability by attempting to exploit the vulnerability. 
In some cases, a successful exploitation will result in changes to the service.


## rustscan

- 📚 [Docs](https://github.com/bee-san/RustScan/wiki/Usage)

> By default, RustScan scans 3000 ports per second.

```shell
rustscan --ulimit 70000 -a <target1>,<target2> -p 22,80,443 
```