📚 [TryHackMe Blue room](https://tryhackme.com/r/room/blue) | [YouTube Walkthrough](https://www.youtube.com/watch?v=32W6Y8fVFzg)


## sample data

[data/windows-hashdump.txt](https://github.com/TurboLabIt/cybersec/tree/main/data)


## setup

1. [Install John the Ripper](https://github.com/TurboLabIt/cybersec/blob/main/script/john-the-ripper/install.sh)


## recon

1. exfiltrate the hashes (e.g.: metasploit "hashdump")


## crack

```shell
/usr/local/john-jumbo/john --format=nt --wordlist=/usr/share/wordlists/rockyou.txt --rules=wordlist hash1.txt
/usr/local/john-jumbo/john --format=nt --show hash1.txt
```
