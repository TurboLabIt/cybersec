## setup

[Install hashcat](https://github.com/TurboLabIt/cybersec/blob/main/script/hashcat/install.sh)


## identify the hash

````shell
hashcat <hash>
```` 

> The following 7 hash-modes match the structure of your input hash:  
> ..

Alternative:

````shell
hashid <hash>
```` 

> [+] SHA-256  
> ...


## map hashing algo to hashcat -m

- MD5 ➡ `-m 0`
- SHA1 ➡ `-m 100`
- SHA256 ➡ `-m 1400`
- md5crypt (UNIX) ➡ `-m 500`
- sha512crypt / $6$ (UNIX) ➡ `-m 1800`
- NTLM (Windows) ➡ `-m 1000`


## crack

````shell
hashcat -m <mapped-value> -a 0 <hash> /usr/share/wordlists/rockyou.txt
````

After the password is cracked, use `--show` to re-show:

````shell
hashcat -m <mapped-value> <hash> --show
````
