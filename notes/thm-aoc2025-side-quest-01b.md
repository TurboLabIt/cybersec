📚 [TryHackMe AoC 2025 - Side Quest](https://tryhackme.com/adventofcyber25/sidequest)  
📚 [The Great Disappearing Act](https://tryhackme.com/room/sq1-aoc2025-FzPnrt2SAu)

note: from Discord I understood that this is actually the FIRST side-quest.


## Initial Access

> This challenge is unlocked by finding the Side Quest key in Advent of Cyber Day 1
> ...
> Unlock the machine by visiting http://<target-ip>:21337 and entering your key. Happy Side Questing!

The website shows a form asking for a key:

> Unlock Hopper's Memories
> The key to unlock this memory can be found on Advent of Cyber - Day 1!

Entering `now_you_see_me` (found in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)) does it:

> The key is correct!
> Unlocking Hopper's memories...

Nothing else. The response is 200, but it sets no cookies. The only unusual thing is this header:

> Server: Werkzeug/3.0.1 Python/3.12.3

[Werkzeug is a comprehensive WSGI web application library](https://werkzeug.palletsprojects.com/en/stable/).


Ah! I later found out that **all the ports on the target machine are stealth unit you do this**!


## recon

Let's nmap the target machine:

````shell
$ zznmap 10.66.173.72

...
Scanning 10.66.173.72 [65535 ports]

Discovered open port 22/tcp
Discovered open port 8080/tcp
Discovered open port 80/tcp
Discovered open port 13403/tcp
Discovered open port 8000/tcp
Discovered open port 13400/tcp
Discovered open port 21337/tcp
Discovered open port 9001/tcp
Discovered open port 13401/tcp
Discovered open port 13404/tcp
Discovered open port 13402/tcp

Completed SYN Stealth Scan at 10:39, 337.46s elapsed (65535 total ports)

PORT      STATE SERVICE            VERSION
22/tcp    open  ssh                OpenSSH 9.6p1 Ubuntu 3ubuntu13.11 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 18:0e:d1:13:80:8e:d7:df:ed:61:73:fb:3b:90:55:0a (ECDSA)
|_  256 94:dc:08:b6:76:e8:e7:45:fa:9a:02:2f:e3:8e:27:30 (ED25519)

80/tcp    open  http               nginx 1.24.0 (Ubuntu)
|_http-server-header: nginx/1.24.0 (Ubuntu)
|_http-title: HopSec Asylum - Security Console
| http-methods: 
|_  Supported Methods: GET HEAD

8000/tcp  open  http-alt
| http-methods: 
|_  Supported Methods: GET HEAD OPTIONS
| http-title: Fakebook - Sign In
|_Requested resource was /accounts/login/?next=/posts/
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 404 Not Found
|     Content-Type: text/html
|     X-Frame-Options: DENY
|     Content-Length: 179
|     Vary: Accept-Language
|     Content-Language: en
|     X-Content-Type-Options: nosniff
|     <!doctype html>
|     <html lang="en">
|     <head>
|     <title>Not Found</title>
|     </head>
|     <body>
|     <h1>Not Found</h1><p>The requested resource was not found on this server.</p>
|     </body>
|     </html>
|   GenericLines, Help, RTSPRequest, SIPOptions, Socks5, TerminalServerCookie: 
|     HTTP/1.1 400 Bad Request
|   GetRequest, HTTPOptions: 
|     HTTP/1.0 302 Found
|     Content-Type: text/html; charset=utf-8
|     Location: /posts/
|     X-Frame-Options: DENY
|     Content-Length: 0
|     Vary: Accept-Language
|     Content-Language: en
|_    X-Content-Type-Options: nosniff

8080/tcp  open  http               SimpleHTTPServer 0.6 (Python 3.12.3)
| http-methods: 
|_  Supported Methods: GET HEAD
|_http-server-header: SimpleHTTP/0.6 Python/3.12.3
|_http-title: HopSec Asylum - Security Console

9001/tcp  open  tor-orport?
| fingerprint-strings: 
|   NULL: 
|     ASYLUM GATE CONTROL SYSTEM - SCADA TERMINAL v2.1 
|     [AUTHORIZED PERSONNEL ONLY] 
|     WARNING: This system controls critical infrastructure
|     access attempts are logged and monitored
|     Unauthorized access will result in immediate termination
|     Authentication required to access SCADA terminal
|     Provide authorization token from Part 1 to proceed
|_    [AUTH] Enter authorization token:

13400/tcp open  hadoop-tasktracker Apache Hadoop 1.24.0 (Ubuntu)
| hadoop-tasktracker-info: 
|_  Logs: loginBtn
|_http-favicon: Unknown favicon MD5: 93B885ADFE0DA089CDF634904FD59F71
| hadoop-datanode-info: 
|_  Logs: loginBtn
|_http-title: HopSec Asylum \xE2\x80\x93 Facility Video Portal
| http-methods: 
|_  Supported Methods: GET HEAD

13401/tcp open  http               Werkzeug httpd 3.1.3 (Python 3.12.3)
|_http-server-header: Werkzeug/3.1.3 Python/3.12.3
|_http-title: 404 Not Found

13402/tcp open  http               nginx 1.24.0 (Ubuntu)
|_http-cors: HEAD GET OPTIONS
|_http-server-header: nginx/1.24.0 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD
|_http-title: Welcome to nginx!

13403/tcp open  unknown
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Help, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NCP, RPCCheck, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|     HTTP/1.1 400 Bad Request
|     Connection: close
|   FourOhFourRequest: 
|     HTTP/1.1 404 Not Found
|     Date: Sun, 28 Dec 2025 15:39:38 GMT
|     Connection: close
|   GetRequest, HTTPOptions: 
|     HTTP/1.1 404 Not Found
|     Date: Sun, 28 Dec 2025 15:39:35 GMT
|     Connection: close
|   RTSPRequest: 
|     HTTP/1.1 404 Not Found
|     Date: Sun, 28 Dec 2025 15:39:36 GMT
|_    Connection: close

13404/tcp open  unknown
| fingerprint-strings: 
|   FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, Kerberos, LDAPSearchReq, LPDString, RTSPRequest, SIPOptions, SSLSessionReq, TLSSessionReq, TerminalServerCookie: 
|_    unauthorized

21337/tcp open  http               Werkzeug httpd 3.0.1 (Python 3.12.3)
| http-methods: 
|_  Supported Methods: GET OPTIONS HEAD
|_http-server-header: Werkzeug/3.0.1 Python/3.12.3
|_http-title: Unlock Hopper's Memories

Running: Linux 4.X
OS CPE: cpe:/o:linux:linux_kernel:4.15
OS details: Linux 4.15
Uptime guess: 24.292 days (since Thu Dec  4 03:41:36 2025)
Network Distance: 3 hops
TCP Sequence Prediction: Difficulty=260 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```` 

There is a lot of stuff here!

- **22**: OpenSSH 9.6p1
- **80**: nginx 1.24.0 - http://10.66.173.72 `HOPSEC ASYLUM - ACCESS TERMINAL`
- **8000**: http://10.66.173.72:8000 `Fakebook - Sign In`
- **8080**: SimpleHTTPServer 0.6 (Python 3.12.3) - http://10.66.173.72:8080/ `HOPSEC ASYLUM - ACCESS TERMINAL`
- **9001**: ASYLUM GATE CONTROL SYSTEM - SCADA TERMINAL v2.1
- **13400**: Apache Hadoop 1.24.0 - http://10.66.173.72:13400 `HopSec Asylum – Facility Video Portal`
- **13401**: Werkzeug httpd 3.1.3 (Python 3.12.3) - http://10.66.173.72:13401 404
- **13402**: nginx 1.24.0 - http://10.66.173.72:13402 Welcome to nginx!
- **13403**: http://10.66.173.72:13403 404
- **13404**: http://10.66.173.72:13404/ unauthorized
- (this was used to start the room) 21337: Werkzeug httpd 3.0.1 (Python 3.12.3) http://10.66.173.72:21337/ `Unlock Hopper's Memories`


## 1. Unlock Hopper’s Cell

From the brief diagram, there's a cam on in the room. Let's probe the `HopSec Asylum – Facility Video Portal` then.

It's on port **13400**: Apache Hadoop 1.24.0 - http://10.66.173.72:13400 

An empty submit posts to **13401** (`Werkzeug httpd 3.1.3 (Python 3.12.3)`)

