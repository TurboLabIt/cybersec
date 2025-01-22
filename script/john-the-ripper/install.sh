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

fxTitle "Remove the non-jumbo package..."
apt remove --purge john -y


fxTitle "Installing prerequisites..."
apt update -qq
apt install build-essential libssl-dev zlib1g-dev -y


fxTitle "Cloning john-jumbo src..."
cd $HOME
rm -rf john-jumbo
git clone https://github.com/openwall/john -b bleeding-jumbo john-jumbo
cd john-jumbo/src


fxTitle "Compiling..."
./configure && make -s clean && make -sj4
cd $HOME


fxTitle "Moving..."
rm -rf /usr/local/john-jumbo
mv john-jumbo /usr/local/john-jumbo
chmod u=rwx,go=rx /usr/local/john-jumbo -R


fxTitle "Symlink..."
rm -f /usr/local/bin/john
ln -s /usr/local/john-jumbo/run/john /usr/local/bin/john

fxTitle "Test..."
john --test


fxTitle "Downloading wordlists from Kali..."
## https://www.kali.org/tools/wordlists/#wordlists
mkdir -p /usr/share/wordlists/
cd /usr/share/wordlists/
curl -o rockyou.txt.gz 'https://gitlab.com/kalilinux/packages/wordlists/-/raw/kali/master/rockyou.txt.gz?ref_type=heads&inline=false'
gunzip rockyou.txt.gz


fxEndFooter
