## sample data

- [data/encrypted-message.gpg](https://github.com/TurboLabIt/cybersec/tree/main/data)
  [data/encrypted-message.key](https://github.com/TurboLabIt/cybersec/tree/main/data)


## decrypt (without importing the key)

````shell
mkdir /tmp/decrypt
gpg --homedir /tmp/decrypt --import encrypted-message.key
gpg --homedir /tmp/decrypt --decrypt encrypted-message.gpg
rm -rf /tmp/decrypt
````


## decrypt (regular flow)

````shell
gpg --import encrypted-message.key
gpg --decrypt encrypted-message.gpg
````
