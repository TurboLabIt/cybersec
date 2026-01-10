If the SSH connects but then closes immediately:

````
$ ssh target.com

Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1044-aws x86_64)
...
Connection to hopaitech.thm closed.
````

It could be due to different reasons.


## SFTP-only

````
sftp zzvm
Connected to zzvm.
sftp>
````


## Tunnel-only

````
ssh -N -L 8080:127.0.0.1:80 target.com 
````

This will tunnel the LOCAL 8080 to the REMOTE 127.0.0.1:80 --> http://localhost:8080 will work.

If the prompt remains open, the tunnel is working.

If it stays open displaying errors, there is nothing listening on the REMOTE port.

note: REMEMBER that 127.0.0.1 here means "on the REMOTE host". To tunnel to a third host, use:

````
ssh -N -L 8080:192.168.111.234:80 target.com 
````
