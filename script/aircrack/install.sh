#!/usr/bin/env bash
### AUTOMATIC AIRCRACK-NG INSTALLER
# https://github.com/TurboLabIt/cybersec/tree/master/script/aircrack/install.sh
#
# sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/aircrack/install.sh | sudo bash
#
# Based on: https://www.aircrack-ng.org/doku.php?id=install_aircrack

## bash-fx
if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "💿 AIRCRACK-NG installer"
rootCheck

fxTitle "Installing prerequisites..."
apt update -qq
#apt install build-essential libssl-dev zlib1g-dev libbz2 curl -y
apt install curl -y

apt install aircrack-ng -y

curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/wordlist/install.sh | bash
