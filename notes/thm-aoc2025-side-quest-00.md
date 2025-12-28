📚 [TryHackMe AoC 2025 - Side Quest](https://tryhackme.com/adventofcyber25/sidequest)  
📚 [How SOC-mas became EAST-mas: Hopper's Origins](https://static-labs.tryhackme.cloud/apps/hoppers-invitation/)

The site requires in "Invitation Code".

note: from Discord I understood that this is NOT the "first side-quest".


## recon

The element has no `<form>`, so it's handled via JS.

On direct submit (no input), the page shows an error:

> Please enter an invitation code

There is no network activity, so it's likely a client-side validation.

If we input a string and submit, the page shows:

> Invalid invitation code. Please try again.

There is also a JS error:

> hoppers-invitation/:1 Access to fetch at 'https://assets.tryhackme.com/additional/aoc2025/files/hopper-origins.txt' from origin 'https://static-labs.tryhackme.cloud' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
> 
> GET https://assets.tryhackme.com/additional/aoc2025/files/hopper-origins.txt net::ERR_FAILED 200 (OK)

That looks like a file! Let's try to open the URL directly:

> hlRAqw3zFxnrgUw1GZusk+whhQHE0F+g7YjWjoJvpZRSCoDzehjXsEX1wQ6TTlOPyEJ/k+AEiMOxdqywh/86AOmhTaXNyZAvbHUVjfMdTqdzxmLXZJwI5ynI


## decrypt

The string gives "almost base64 vibes" (even if it doesn't end with `==`), but [cyberchef.io/](https://cyberchef.io/) "magic" recipe doesn't help.

base64-decode gives binary data. File doesn't help:

````shell
$ echo "hlRAqw3zFxnrgUw1GZusk+whhQHE0F+g7YjWjoJvpZRSCoDzehjXsEX1wQ6TTlOPyEJ/k+AEiMOxdqywh/86AOmhTaXNyZAvbHUVjfMdTqdzxmLXZJwI5ynI" | base64 -d > hopper-origins.bin

$ file hopper-origins.bin
hopper-origins.bin: data
````

Things I tried:

- OpenSSL-decode with the key found in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)
- GPG-decode with the key found in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)
