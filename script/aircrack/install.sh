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

sudo apt update && sudo apt install aircrack-ng -y

fxEndFooter
