#!/usr/bin/env bash
### AUTOMATIC BURP SUITE INSTALLER
# https://github.com/TurboLabIt/cybersec/tree/master/script/burp-suite/install.sh
#
# sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/burp-suite/install.sh | sudo bash
#
## bash-fx
if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "💿 BURP SUITE installer"
rootCheck

fxTitle "Installing prerequisites..."
apt update -qq
apt install curl -y

fxTitle "Downloading..."
cd /tmp
curl -Lo "burp-suite.sh" 'https://portswigger-cdn.net/burp/releases/download?product=community&version=2025.1.4&type=Linux'

fxTitle "Starting the installer..."
bash burp-suite.sh

fxTitle "Removing the installer..."
rm -rf burp-suite.sh

fxEndFooter
