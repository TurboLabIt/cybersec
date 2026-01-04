📚 [TryHackMe AoC 2025 - Side Quest](https://tryhackme.com/adventofcyber25/sidequest)  
📚 [Carrotbane of My Existence](https://tryhackme.com/room/sq3-aoc2025-bk3vvbcgiT)


## Initial Access

> This challenge is unlocked by finding the Side Quest key in Advent of Cyber Day 17
> ...
> Unlock the machine by visiting MACHINE_IP:21337 and entering your key.

http://10.65.188.33:21337

Entering `one_hopper_army` (found in [thm-aoc2025-side-quest-03a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-03a.md)) does it -  
See [thm-aoc2025-side-quest-01b.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01b.md) for details.


## recon

Let's nmap the target machine:

````shell
$ zznmap 10.65.188.33

...


````

