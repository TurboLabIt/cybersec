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
apt install build-essential libssl-dev zlib1g-dev libbz2 curl -y


fxTitle "Cloning john-jumbo src..."
cd /tmp
rm -rf john-jumbo
git clone https://github.com/openwall/john -b bleeding-jumbo john-jumbo
cd john-jumbo/src


fxTitle "Compiling..."
./configure && make -s clean && make -sj4
cd /tmp


fxTitle "Moving..."
rm -rf /usr/local/john-jumbo
mv john-jumbo/run /usr/local/john-jumbo
chmod u=rwx,go=rx /usr/local/john-jumbo -R
rm -rf /tmp/john-jumbo

fxTitle "Test..."
/usr/local/john-jumbo/john --test


curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/wordlist/install.sh | sudo bash
