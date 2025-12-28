📚 [Linux CLI - Shells Bells](https://tryhackme.com/room/linuxcli-aoc2025-o1fpqkvxti)

> For those who consider themselves intermediate and want another challenge, check McSkidy's hidden note in `/home/mcskidy/Documents/` to get access to the key for **Side Quest 1**! Accessible through our [Side Quest Hub](https://tryhackme.com/adventofcyber25/sidequest)!


## brief

The folder contains a plaintext file (`/home/mcskidy/Documents/read-me-please.txt`):

````shell
$ cat read-me-please.txt 
From: mcskidy
To: whoever finds this

I had a short second when no one was watching. I used it.

I've managed to plant a few clues around the account.
If you can get into the user below and look carefully,
those three little "easter eggs" will combine into a passcode
that unlocks a further message that I encrypted in the
/home/eddi_knapp/Documents/ directory.
I didn't want the wrong eyes to see it.

Access the user account:
username: eddi_knapp
password: S0mething1Sc0ming

There are three hidden easter eggs.
They combine to form the passcode to open my encrypted vault.

Clues (one for each egg):

1)
I ride with your session, not with your chest of files.
Open the little bag your shell carries when you arrive.

2)
The tree shows today; the rings remember yesterday.
Read the ledger’s older pages.

3)
When pixels sleep, their tails sometimes whisper plain words.
Listen to the tail.

Find the fragments, join them in order, and use the resulting passcode
to decrypt the message I left. Be careful — I had to be quick,
and I left only enough to get help.

~ McSkidy
````

Key points:

- there is a 3-parts key to find on the target machine
- the key can be used to decrypt a note (`/home/eddi_knapp/Documents/`)


## eddi_knapp directory

The brief mentions the home of a different user (`/home/eddi_knapp/Documents/`).

The user credentials are provided, but let's try to sudo:

````shell
sudo -s
````

Sudo worked, no need for credentials.

````shell
cd /home/eddi_knapp/
ls -la
````

Some files stand out:

````shell
drwxr-x--- 18 eddi_knapp eddi_knapp 4096 Dec  1 08:52 .
drwxr-xr-x  6 root       root       4096 Oct 10 17:27 ..
-rw-r--r--  1 eddi_knapp eddi_knapp 3797 Nov 11 16:24 .bashrc
-rw-r--r--  1 eddi_knapp eddi_knapp 3797 Nov 11 16:19 .bashrc.bak
drwxrwxr-x  2 eddi_knapp eddi_knapp 4096 Nov 11 16:24 fix_passfrag_backups_20251111162432
drwx------  3 eddi_knapp eddi_knapp 4096 Dec  1 08:32 .gnupg
-rw-------  1 eddi_knapp eddi_knapp   68 Oct 10 18:16 .image_meta
-rw-------  1 eddi_knapp eddi_knapp   19 Nov 11 16:30 .pam_environment
-rw-------  1 eddi_knapp eddi_knapp   19 Nov 11 16:24 .pam_environment.bak
-rw-r--r--  1 eddi_knapp eddi_knapp  833 Nov 11 16:30 .profile
-rw-r--r--  1 eddi_knapp eddi_knapp  833 Nov 11 16:24 .profile.bak
drwxrwxr-x  2 eddi_knapp eddi_knapp 4096 Dec  1 08:32 .secret
drwx------  3 eddi_knapp eddi_knapp 4096 Nov 11 12:07 .secret_git
drwx------  3 eddi_knapp eddi_knapp 4096 Oct  9 17:20 .secret_git.bak
-rw-------  1 eddi_knapp eddi_knapp 7167 Nov 11 16:23 .viminfo
-rw-rw-r--  1 eddi_knapp eddi_knapp  429 Oct  9 17:53 wget-log
````


## key, part-1

`.bashrc.bak`: it looks like the user made a backup before editing...

````shell
$ cat .bashrc
...
export PASSFRAG1="3ast3r"
````

First part found.


## raw search

Let's try and go raw:

````shell
$ grep -Ri PASSFRAG
Pictures/.easter_egg:PASSFRAG3: c0M1nG
...
.bashrc:export PASSFRAG1="3ast3r"
...
````

Found part-3, but not part-2.


## key, part 2

The hint was:

> Read the ledger’s older pages

It's likely a Git reference, and there is a `.secret_git/` directory. It's empty, but has `.git` sub-folder.

````shell
$ cd .secret_git
$ sudo -u eddi_knapp git log

commit e924698378132991ee08f050251242a092c548fd (HEAD -> master)
    remove sensitive note

commit d12875c8b62e089320880b9b7e41d6765818af3d
    add private note
````

That commit looks promising.

````shell
sudo -u eddi_knapp git checkout d12875c8b62e089320880b9b7e41d6765818af3d
````

A `secret_note.txt` file was restored:

````shell
========================================
Private note from McSkidy
========================================
We hid things to buy time.
PASSFRAG2: -1s-
````

## key, part 3

`c0M1nG`, found before.


## key concat

The key is: `3ast3r-1s-c0M1nG`.


## decipher

The brief mentioned an encrypted file in `/home/eddi_knapp/Documents/`. There is `mcskidy_note.txt.gpg`.

Having the .gpg ext, it's likely gpg-encrypted:

````shell
$ gpg -d mcskidy_note.txt.gpg 
gpg: directory '/root/.gnupg' created
gpg: keybox '/root/.gnupg/pubring.kbx' created
gpg: AES256.CFB encrypted data
gpg: encrypted with 1 passphrase
Congrats — you found all fragments and reached this file.

Below is the list that should be live on the site. If you replace the contents of
/home/socmas/2025/wishlist.txt with this exact list (one item per line, no numbering),
the site will recognise it and the takeover glitching will stop. Do it — it will save the site.

Hardware security keys (YubiKey or similar)
Commercial password manager subscriptions (team seats)
Endpoint detection & response (EDR) licenses
Secure remote access appliances (jump boxes)
Cloud workload scanning credits (container/image scanning)
Threat intelligence feed subscription

Secure code review / SAST tool access
Dedicated secure test lab VM pool
Incident response runbook templates and playbooks
Electronic safe drive with encrypted backups

A final note — I don't know exactly where they have me, but there are *lots* of eggs
and I can smell chocolate in the air. Something big is coming.  — McSkidy

---

When the wishlist is corrected, the site will show a block of ciphertext. This ciphertext can be decrypted with the following unlock key:

UNLOCK_KEY: 91J6X7R4FQ9TQPM9JX2Q9X2Z

To decode the ciphertext, use OpenSSL. For instance, if you copied the ciphertext into a file /tmp/website_output.txt you could decode using the following command:

cat > /tmp/website_output.txt
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -salt -base64 -in /tmp/website_output.txt -out /tmp/decoded_message.txt -pass pass:'91J6X7R4FQ9TQPM9JX2Q9X2Z'
cat /tmp/decoded_message.txt

Sorry to be so convoluted, I couldn't risk making this easy while King Malhare watches. — McSkidy
````


## find the website

The note says:

> the site will show a block of ciphertext

Which site? `http://<machine-ip>` returns 405 (`Message: Method Not Allowed.`).

Let's see if there is something else running:

````shell
$ zznmap
Discovered open port 22/tcp
Discovered open port 8080/tcp
Discovered open port 80/tcp
````

Alternative:

````shell
$ ss -lptn
State     Recv-Q    Send-Q       Local Address:Port       Peer Address:Port   Process
LISTEN    0         5                  0.0.0.0:5901            0.0.0.0:*       users:(("Xtigervnc",pid=1384,fd=9))   
LISTEN    0         511                0.0.0.0:8081            0.0.0.0:*       users:(("node",pid=1015,fd=24))   
LISTEN    0         5                  0.0.0.0:8080            0.0.0.0:*       users:(("python3",pid=1013,fd=3))   
LISTEN    0         4096            127.0.0.54:53              0.0.0.0:*       users:(("systemd-resolve",pid=279,fd=17))   
LISTEN    0         4096             127.0.0.1:631             0.0.0.0:*       users:(("cupsd",pid=1003,fd=7))   
LISTEN    0         4096               0.0.0.0:22              0.0.0.0:*       users:(("sshd",pid=2995,fd=3),("systemd",pid=1,fd=249))   
LISTEN    0         100                0.0.0.0:80              0.0.0.0:*       users:(("python3",pid=2549,fd=3),("python3",pid=1328,fd=3))
````

`http://<machine-ip>:8080` shows the site.


## restore the website, get the flag

Replace the text in the file as described in the note, then refresh the website to see the get the encrypted string:

````shell
U2FsdGVkX1/7xkS74RBSFMhpR9Pv0PZrzOVsIzd38sUGzGsDJOB9FbybAWod5HMsa+WIr5HDprvK6aFNYuOGoZ60qI7axX5Qnn1E6D+BPknRgktrZTbMqfJ7wnwCExyU8ek1RxohYBehaDyUWxSNAkARJtjVJEAOA1kEOUOah11iaPGKxrKRV0kVQKpEVnuZMbf0gv1ih421QvmGucErFhnuX+xv63drOTkYy15s9BVCUfKmjMLniusI0tqs236zv4LGbgrcOfgir+P+gWHc2TVW4CYszVXlAZUg07JlLLx1jkF85TIMjQ3B91MQS+btaH2WGWFyakmqYltz6jB5DOSCA6AMQYsqLlx53ORLxy3FfJhZTl9iwlrgEZjJZjDoXBBMdlMCOjKUZfTbt3pnlHWEaGJD7NoTgywFsIw5cz7hkmAMxAIkNn/5hGd/S7mwVp9h6GmBUYDsgHWpRxvnjh0s5kVD8TYjLzVnvaNFS4FXrQCiVIcp1ETqicXRjE4T0MYdnFD8h7og3ZlAFixM3nYpUYgKnqi2o2zJg7fEZ8c=
````

Decode it with the OpenSSL command provide in the note:

````shell
Well done — the glitch is fixed. Amazing job going the extra mile and saving the site. Take this flag THM{w3lcome_2_A0c_2025}

NEXT STEP:
If you fancy something a little...spicier....use the FLAG you just obtained as the passphrase to unlock:
/home/eddi_knapp/.secret/dir

That hidden directory has been archived and encrypted with the FLAG.
Inside it you'll find the sidequest key.
````


## decrypt the file 

The note reveals `/home/eddi_knapp/.secret/dir.tar.gz.gpg`. We need to:

1. decrypt the file
2. un-tar.gz (which is always loads of fun)

````shell
$ cd /home/eddi_knapp/.secret/
$ gpg -d dir.tar.gz.gpg > dir.tar.gz
$ tar -zxvf dir.tar.gz
dir/
dir/sq1.png
````


## image analysis

Download the extracted image for analysis:

````shell
cp /home/eddi_knapp/.secret/dir/sq1.png /home/mcskidy/
sudo chmod ugo=rwx /home/mcskidy/sq1.png
````

````shell
scp mcskidy@10.66.147.12:sq1.png .
````

The file is an actual image, showing the text `now_you_see_me`.

[image-steganography.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/image-steganography.md) returns nothing.

This late in the game, it's likely that the text shown in image is actually the flag.


## next step

From Discord I understood that the next step is NOT "How SOC-mas became EAST-mas: Hopper's Origins" ([thm-aoc2025-side-quest-00.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-00.md)), but:

➡ "The Great Disappearing Act" ([thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md))
