📚 [TryHackMe Takeover (Futurevera)](https://tryhackme.com/room/takeover)


## setup

1. [Install nmap](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

> Discovered open port 22/tcp  
> Discovered open port 80/tcp  
> Discovered open port 443/tcp


## website

The HTTPS cert is self-signed+expired. Common Name: `futurevera.thm`.


The website has some listable folder:

- https://futurevera.thm/css/ 
- https://futurevera.thm/js/
- https://futurevera.thm/assets/

Nothing relevant in there.


## support.futurevera.thm

The brief mentions:

> we are rebuilding our support

Let's try to also map:

````
sudo nano /etc/hosts

10.65.176.228   futurevera.thm support.futurevera.thm help.futurevera.thm ticket.futurevera.thm
````

https://support.futurevera.thm exits. 

The HTTPS cert is self-signed+expired. Common Name: `support.futurevera.thm`, DNS Name
`secrethelpdesk934752.support.futurevera.thm`

It has the same listable folders:

- https://support.futurevera.thm/css/
- https://support.futurevera.thm/js/
- https://support.futurevera.thm/assets/


## secrethelpdesk934752.support.futurevera.thm

````
$ sudo nano /etc/hosts

10.65.176.228   futurevera.thm support.futurevera.thm secrethelpdesk934752.support.futurevera.thm
````

https://secrethelpdesk934752.support.futurevera.thm doesn't work (it shows the standard website).

http://secrethelpdesk934752.support.futurevera.thm works, but it does a strange redirect:

````shell
$ curl http://secrethelpdesk934752.support.futurevera.thm --head
HTTP/1.1 302 Found
Location: http://flag{beea0d6edfcee06a59b83fb50ae81b2f}.s3-website-us-west-3.amazonaws.com/
````

The flag is right there: `flag{beea0d6edfcee06a59b83fb50ae81b2f}`.
