#!/usr/bin/env bash
### WORDLIST DOWNLOADER
# https://github.com/TurboLabIt/cybersec/tree/master/script/wordlist/install.sh
#
# sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/wordlist/install.sh | sudo bash

## bash-fx
if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "💿 WORDLIST downloader"
rootCheck

fxTitle "Installing prerequisites..."
apt update -qq
apt install curl unzip -y

fxTitle "Creating the directory..."
mkdir -p /usr/share/wordlists/
cd /usr/share/wordlists/

fxTitle "Downloading rockyou from Kali..."
## https://www.kali.org/tools/wordlists/#wordlists
curl -o rockyou.txt.gz 'https://gitlab.com/kalilinux/packages/wordlists/-/raw/kali/master/rockyou.txt.gz?ref_type=heads&inline=false'
gunzip rockyou.txt.gz


fxEndFooter
