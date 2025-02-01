## capture the WPA handshake

[notes/000-aircrack.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/000-aircrack.md)


## setup

[Install hashcat](https://github.com/TurboLabIt/cybersec/blob/main/script/hashcat/install.sh)


## convert .cap to .22000

````shell
hcxpcapngtool -o handshake.22000 wifi-capture.cap

````

These warnings are "normal":

> Warning: out of sequence timestamps!
> Warning: out of sequence timestamps!


## crack

````shell
hashcat -m 22000 handshake.22000 /usr/share/wordlists/rockyou.txt

````
