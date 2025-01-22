#!/usr/bin/env bash
### AUTOMATIC JOHN THE RIPPER INSTALLER
# https://github.com/TurboLabIt/cybersec/tree/master/script/john-the-ripper/install.sh
#
# sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/john-the-ripper/install.sh | sudo bash

## bash-fx
if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "💿 JOHN THE RIPPER installer"
rootCheck

apt update && apt install john -y


fxTitle "Downloading wordlist from Kali..."
## https://www.kali.org/tools/wordlists/#wordlists
mkdir /usr/share/wordlists/
cd /usr/share/wordlists/
curl -o rockyou.txt.gz 'https://gitlab.com/kalilinux/packages/wordlists/-/raw/kali/master/rockyou.txt.gz?ref_type=heads&inline=false'
gunzip rockyou.txt.gz


fxEndFooter
