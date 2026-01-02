## Crack ZIPs with John The Ripper

Install:

````shell
sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/john-the-ripper/install.sh | sudo bash
````

Convert and crack:

````shell
zip2john flag.zip > flag.zip.john
john --wordlist=/usr/share/wordlists/rockyou.txt flag.zip.john
````
