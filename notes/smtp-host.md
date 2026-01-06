## temporary, quick

````shell
sudo apt update
sudo apt install python3-aiosmtpd -y
sudo python3 -m aiosmtpd -l 0.0.0.0:25
````


## test

````shell
swaks --to victim@example.com --from hacker@evil.com --server localhost --port 25
````