In the context of a CTF, if you see a service running on port 53 (DNS), the "listing its content" technique is called a **DNS Zone Transfer (AXFR)**

If the server is misconfigured to allow this, it will basically **dump the entire database of subdomains and records** for that zone.

````shell
$ dig @10.67.175.25 hopaitech.thm axfr
...

hopaitech.thm.          3600    IN      SOA     ns1.hopaitech.thm. admin.hopaitech.thm. 1 3600 1800 604800 86400
dns-manager.hopaitech.thm. 3600 IN      A       172.18.0.3
ns1.hopaitech.thm.      3600    IN      A       172.18.0.3
ticketing-system.hopaitech.thm. 3600 IN A       172.18.0.2
url-analyzer.hopaitech.thm. 3600 IN     A       172.18.0.3
hopaitech.thm.          3600    IN      NS      ns1.hopaitech.thm.hopaitech.thm.
hopaitech.thm.          3600    IN      SOA     ns1.hopaitech.thm. admin.hopaitech.thm. 1 3600 1800 604800 86400

...
````
