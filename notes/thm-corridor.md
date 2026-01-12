📚 [TryHackMe Corridor (Authentication Anywhere)](https://tryhackme.com/room/corridor)

the brief states "IDOR vulnerabilities", so the flaw must be an IDOR.


## recon

The website shows the picture of a corridor with **13** doors.  Each door is a link (`<map name="image-map">`).

The door on the left have these URLs:

- http://10.64.145.188/c4ca4238a0b923820dcc509a6f75849b
- http://10.64.145.188/c81e728d9d4c2f636f067f89cc14862c
- http://10.64.145.188/eccbc87e4b5ce2fe28308fd9f2a7baf3
- http://10.64.145.188/a87ff679a2f3e71d9181a67b7542122c
- http://10.64.145.188/e4da3b7fbbce2345d7772b0674a318d5
- http://10.64.145.188/1679091c5a880faf6fb5e6087eb1b2dc

There's nothing useful in the HTML.


## decoding

Those strings are MD5 hashes of consecutive integers:

- c4ca4238a0b923820dcc509a6f75849b = **md5("1")**
- c81e728d9d4c2f636f067f89cc14862c = **md5("2")**
- eccbc87e4b5ce2fe28308fd9f2a7baf3 = **md5("3")**
- ....

Since the brief states "Can you find your way **back**?", the URL must be **md5("0")**:

http://10.64.145.188/cfcd208495d565ef66e7dff9f98764da

The URL shows the flag: `flag{2477ef02448ad9156661ac40a6b8862e}`.
