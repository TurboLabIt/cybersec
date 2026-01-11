#!/usr/bin/env bash

## bash-fx
if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi
if [ ! -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/master/setup.sh | sudo bash; fi
source /usr/local/turbolab.it/bash-fx/bash-fx.sh
## bash-fx is ready

fxHeader "🏴‍☠️ Startup..."


fxTitle "Working dir"
ZZDIR=/mnt/hgfs/cybersec/attackbox/
fxInfo ${ZZDIR}
cd ${ZZDIR}
pwd
ls -l


fxTitle "Deploying zzstartup..."
sudo chmod ugo= ${ZZDIR}startup.sh
sudo chmod u=rwx,go=rx ${ZZDIR}startup.sh
sudo rm -f /usr/local/bin/zzstartup
sudo ln -s ${ZZDIR}startup.sh /usr/local/bin/zzstartup
ls -l  /usr/local/bin/


fxTitle "Deploying cron..."
sudo rm -f /etc/cron.d/zane
sudo cp ${ZZDIR}startup.cron /etc/cron.d/attackbox
ls -l /etc/cron.d/


fxTitle "Fixing startup log permissions..."
sudo touch /var/log/zzstatup.log
sudo chmod ugo=rw /var/log/zzstatup.log


sudo bash ${ZZDIR}thm-vpn/zzvpn.sh
