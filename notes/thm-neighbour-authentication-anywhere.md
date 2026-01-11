📚 [TryHackMe Neighbour (Authentication Anywhere)](https://tryhackme.com/room/neighbour)

the brief suggest "similar content: IDOR", so the flaw must be an IDOR.


## recon

The website shows a login form with a guest account available

> Don't have an account? Use the guest account!

The source of the page has a HTML-comment:

> use guest:guest credentials until registration is fixed. "admin" user account is off limits!!!!!


## login

After we login as guest, the URL is:

````
http://10.65.131.115/profile.php?user=guest
````

We already know that:

- the room is about IDOR
- there is an `admin` account

We can try and change the URL to:

````
http://10.65.131.115/profile.php?user=admin
````

We get the flag: `flag{66be95c478473d91a5358f2440c7af1f}`
