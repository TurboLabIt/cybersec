📚 [TryHackMe Brooklyn Nine Nine](https://tryhackme.com/room/brooklynninenine)


## setup

1. [Install nmap](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

````shell
$ zznmap 10.65.129.83

...
Discovered open port 21/tcp
Discovered open port 22/tcp
Discovered open port 80/tcp
...
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_-rw-r--r--    1 0        0             119 May 17  2020 note_to_jake.txt
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:192.168.130.14
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 4
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 16:7f:2f:fe:0f:ba:98:77:7d:6d:3e:b6:25:72:c6:a3 (RSA)
|   256 2e:3b:61:59:4b:c4:29:b5:e8:58:39:6f:6f:e9:9b:ee (ECDSA)
|_  256 ab:16:2e:79:20:3c:9b:0a:01:9c:8c:44:26:01:58:04 (ED25519)

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.29 (Ubuntu)
| http-methods: 
|_  Supported Methods: HEAD GET POST OPTIONS
...
````

- **21**: vsftpd 3.0.3
- **22**: OpenSSH 7.6p1 Ubuntu
- **80**: Apache httpd 2.4.29 ((Ubuntu))


The main application at http://10.65.129.83 shows a full-page image.

The source has this hint:

````html
<!-- Have you ever heard of steganography? -->
````

## de-steg the image

[notes/image-steganography.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/image-steganography.md)

````shell
$ stegseek brooklyn99.jpg /usr/share/wordlists/rockyou.txt

[i] Found passphrase: "admin"
[i] Original filename: "note.txt".
[i] Extracting to "brooklyn99.jpg.out".
````

The extracted file contains this message:

> Holts Password:
> fluffydog12@ninenine
> Enjoy!!

note: [in the show, the name of the character is](https://en.wikipedia.org/wiki/Brooklyn_Nine-Nine)
*Captain Raymond **Holt***. So the message should be "Holt's Password" --> the username is likely `holt`.

