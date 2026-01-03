#!/usr/bin/env bash

## sudo nano /etc/cron.d/zane && sudo reboot
#MAILTO=""
#@reboot root sleep 3 && sudo mount-shared-folders > /dev/null 2>&1
#@reboot root sudo bash /mnt/hgfs/cybersec/attackbox/startup.sh > /dev/null 2>&1

sleep 10
sudo bash /mnt/hgfs/cybersec/attackbox/thm-vpn/zzvpn.sh
