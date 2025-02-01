📚 [TryHackMe Blue room](https://tryhackme.com/r/room/blue) | [YouTube Walkthrough](https://www.youtube.com/watch?v=32W6Y8fVFzg)


## sample data

[data/windows-hashdump.txt](https://github.com/TurboLabIt/cybersec/tree/main/data)


## setup

[Install John the Ripper](https://github.com/TurboLabIt/cybersec/blob/main/script/john-the-ripper/install.sh)


## recon

exfiltrate the hashes (e.g.: metasploit "hashdump")


## crack

```shell
/usr/local/john-jumbo/john --format=nt --wordlist=/usr/share/wordlists/rockyou.txt --rules=wordlist windows-hashdump.txt
/usr/local/john-jumbo/john --format=nt --show windows-hashdump.txt
```
