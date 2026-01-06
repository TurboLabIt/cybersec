## temporary, quick

````shell
cd /home/web
sudo python3 -m http.server 80
````

Without `sudo` and `80`, it would run on `8000`. It's safer, but harder to inject.


## long-term

[webstackup/nginx](https://github.com/TurboLabIt/webstackup/blob/master/script/nginx/install.sh). Safer, more flexible.


## test

````shell
curl -i http://127.0.0.1
````
