[Wifi Hacking 101](https://tryhackme.com/r/room/wifihacking101?ref=blog.tryhackme.com) | [Tutorial: How to Crack WPA/WPA2](https://aircrack-ng.org/doku.php?id=cracking_wpa)


## setup

1. [Install Aircrack-ng](https://github.com/TurboLabIt/cybersec/blob/main/script/aircrack/install.sh)


## network interfaces

````shell
iw dev
iw dev wlan0 info

````


## monitor mode

the Wi-Fi interface listens to all wireless traffic on a specific channel, regardless of whether 
it is directed to the device or not.
It passively captures all network traffic within range for analysis without joining a network.

````shell
sudo ip link set dev wlan0 down
sudo iw dev wlan0 set type monitor
sudo ip link set dev wlan0 up

````

Alternative:

````shell
sudo airmon-ng start wlan0

````


## recon

MAC == BSSID (Bervice Set Identifier)

````shell
iw dev wlan0 scan

````

Alternative:

````shell
sudo airodump-ng wlan0

````


## capture

````shell
sudo airodump-ng -c <network-channel-number> --bssid <access-point-mac-address> -w output-file network-capture.pcap

````
