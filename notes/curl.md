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

Use [Hydra](https://github.com/TurboLabIt/cybersec/blob/main/notes/hydra-login-http.md)
