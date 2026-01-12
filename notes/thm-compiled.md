📚 [TryHackMe Compiled](https://tryhackme.com/room/compiled)

There's a file to download: `compiled-1688545393558.Compiled`.

The brief states: 

> The binary will not execute if using the AttackBox

So: we are expected to decompile it


## recon

````
$ file Compiled-1688545393558.Compiled 

Compiled-1688545393558.Compiled: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=06dcfaf13fb76a4b556852c5fbf9725ac21054fd, for GNU/Linux 3.2.0, not stripped
````

The file is a Linux executable (ELF).

````
$ strings Compiled-1688545393558.Compiled

..
StringsIH
sForNoobH
Password: 
DoYouEven%sCTF
__dso_handle
...
````

`DoYouEven%sCTF` looks promising, but it's not the flag.


## decompile

Decompile it with [notes/ghidra.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/ghidra-decompile.md):

````
...
fwrite("Password: ",1,10,stdout);
  __isoc99_scanf("DoYouEven%sCTF",local_28);
  iVar1 = strcmp(local_28,"__dso_handle");
  if ((-1 < iVar1) && (iVar1 = strcmp(local_28,"__dso_handle"), iVar1 < 1)) {
    printf("Try again!");
    return 0;
  }
  iVar1 = strcmp(local_28,"_init");
  if (iVar1 == 0) {
    printf("Correct!");
  }
...
````

The answer is `DoYouEven_init`.
