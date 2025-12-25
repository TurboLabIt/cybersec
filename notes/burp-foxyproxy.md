## install

````shell
sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/burp-suite/install.sh | sudo bash
````


## Browser integration

Install [FoxyProxy browser extension](https://getfoxyproxy.org/help/browsers/).

`Options -> Proxies -> Add`:

- Type: `HTTP`
- Hostname: `127.0.0.1`
- Port: `8080`

Now:

1. Enable the proxy (via the browser toolbar icon)
2. Visit any HTTP**S** site
3. Download and trust the provider cert
