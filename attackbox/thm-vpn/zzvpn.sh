#!/usr/bin/env bash

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi
if [ ! -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/master/setup.sh | sudo bash; fi
source /usr/local/turbolab.it/bash-fx/bash-fx.sh
## bash-fx is ready

fxHeader "zzvpn"


if [ -z "$(command -v openvpn)" ]; then

  fxTitle "Installing OpenVPN..."
  sudo apt update
  sudo apt install openvpn -y

else

  fxTitle "Killing any OpenVPN connection..."
  sudo pkill -f openvpn
fi

fxTitle "Connecting..."
sudo openvpn /mnt/hgfs/cybersec/attackbox/thm-vpn/thm-us-east.ovpn > /dev/null 2>&1 &
sleep 3

fxTitle "My VPN IP is..."
ip -o -4 addr show tun0 | awk '{print $4}' | cut -d/ -f1
echo ""
