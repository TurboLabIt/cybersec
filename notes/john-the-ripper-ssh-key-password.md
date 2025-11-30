📚 [John the Ripper: Beginner’s Tutorial and Review](https://www.esecurityplanet.com/products/john-the-ripper/)


## sample data

[data/linux-ssh-key](https://github.com/TurboLabIt/cybersec/tree/main/data)


## setup

[Install John the Ripper](https://github.com/TurboLabIt/cybersec/blob/main/script/john-the-ripper/install.sh)


## convert

````shell
ssh2john id_rsa > id_rsa.hash
````

## crack

````shell
john barry-key.hash --wordlist=/usr/share/wordlists/rockyou.txt
````

After the password is cracked, use `--show` to re-show:

````shell
john barry-key.hash --show
````