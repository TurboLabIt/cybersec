📚 [Passwords - A Cracking Christmas](https://tryhackme.com/room/attacks-on-ecrypted-files-aoc2025-asdfghj123)

> For those who want another challenge, have a look around the VM to get access to the key for **Side Quest 2**!


The file to find is `/home/ubuntu/.Password.kdbx`. It's KeePass [KDBX 4 file format](https://keepass.info/help/kb/kdbx_4.html).

scp it to your attacker machine.

As of Jan 2026, the *keepass2john* utility bundled with Kali cannot handle it yet. You need to install:

💽 [John Jumbo](https://github.com/TurboLabIt/cybersec/tree/master/script/john-the-ripper/install.sh)

Then:

````shell
/usr/local/john-jumbo/keepass2john passwords.kdbx > passwords.kdbx.john
/usr/local/john-jumbo/john --wordlist=/usr/share/wordlists/rockyou.txt passwords.kdbx.john
````

The password of the database is `harrypotter`.

Install KeePass:

````shell
sudo apt update && sudo apt install keepass2 -y
````

Now:

1. open the kdbx file
2. open the single password entry
3. save the attached `sq2.png`
4. the image shows a password: `tit_for_tat`

[image-steganography.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/image-steganography.md) returns nothing.

That's likely it, as it was for sq1.png in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)

## next step

➡ "Scheme Catcher" [thm-aoc2025-side-quest-02b.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-02b.md)
