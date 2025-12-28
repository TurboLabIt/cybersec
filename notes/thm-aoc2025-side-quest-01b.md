📚 [TryHackMe AoC 2025 - Side Quest](https://tryhackme.com/adventofcyber25/sidequest)  
📚 [The Great Disappearing Act](https://tryhackme.com/room/sq1-aoc2025-FzPnrt2SAu)

note: from Discord I understood that this is actually the FIRST side-quest.


## Initial Access

> This challenge is unlocked by finding the Side Quest key in Advent of Cyber Day 1
> ...
> Unlock the machine by visiting http://<target-ip>:21337 and entering your key. Happy Side Questing!

The website shows a form asking for a key:

> Unlock Hopper's Memories
> The key to unlock this memory can be found on Advent of Cyber - Day 1!

Entering `now_you_see_me` (found in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)) does it:

> The key is correct!
> Unlocking Hopper's memories...

Nothing else. The response is 200, but it sets no cookies. The only unusual thing is this header:

> Server: Werkzeug/3.0.1 Python/3.12.3

[Werkzeug is a comprehensive WSGI web application library](https://werkzeug.palletsprojects.com/en/stable/).

