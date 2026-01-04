📚 [yberChef - Hoperation Save McSkidy](https://tryhackme.com/room/encoding-decoding-aoc2025-s1a4z7x0c3)

> Looking for the key to **Side Quest 3**? Hopper has left us this [cyberchef link](https://gchq.github.io/CyberChef/#recipe=To_Base64('A-Za-z0-9%2B/%3D')Label('encoder1')ROT13(true,true,false,7)Split('H0','H0%5C%5Cn')Jump('encoder1',8)Fork('%5C%5Cn','%5C%5Cn',false)Zlib_Deflate('Dynamic%20Huffman%20Coding')XOR(%7B'option':'UTF8','string':'h0pp3r'%7D,'Standard',false)To_Base32('A-Z2-7%3D')Merge(true)Generate_Image('Greyscale',1,512)&input=SG9wcGVyIG1hbmFnZWQgdG8gdXNlIEN5YmVyQ2hlZiB0byBzY3JhbWJsZSB0aGUgZWFzdGVyIGVnZyBrZXkgaW1hZ2UuIEhlIHVzZWQgdGhpcyB2ZXJ5IHJlY2lwZSB0byBkbyBpdC4gVGhlIHNjcmFtYmxlZCB2ZXJzaW9uIG9mIHRoZSBlZ2cgY2FuIGJlIGRvd25sb2FkZWQgZnJvbTogCgpodHRwczovL3RyeWhhY2ttZS1pbWFnZXMuczMuYW1hem9uYXdzLmNvbS91c2VyLXVwbG9hZHMvNWVkNTk2MWM2Mjc2ZGY1Njg4OTFjM2VhL3Jvb20tY29udGVudC81ZWQ1OTYxYzYyNzZkZjU2ODg5MWMzZWEtMTc2NTk1NTA3NTkyMC5wbmcKClJldmVyc2UgdGhlIGFsZ29yaXRobSB0byBnZXQgaXQgYmFjayE) as a lead

> Hopper managed to use CyberChef to scramble the easter egg key image. He used this very recipe to do it. The scrambled version of the egg can be downloaded from:
> 
> https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1765955075920.png
> 
> Reverse the algorithm to get it back!


## analysis

The image is generated as a chain of functions. We must apply the reverse of each function, starting from the bottom.


## image back-conversion

````shell
$ curl -o egg_scrambled.png https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1765955075920.png

$ file egg_scrambled.png 
egg_scrambled.png: PNG image data, 512 x 1448, 8-bit/color RGBA, non-interlaced
````

To obtain the raw data from the PNG:

````shell
python3 -c "from PIL import Image; import sys; sys.stdout.buffer.write(bytearray(Image.open('egg_scrambled.png ').convert('L').getdata()))" > egg_scrambled.png.bin
````

Upload the genetated file to CyberChef.


## original recipe

Name of the fx applied ➡ How to reverse it

1. To Base64 (A-Za-z0-9+/=) ➡ **From Base64 (A-Za-z0-9+/=)**
2. Label (encoder1) ➡ **Jump (encoder1, 8)**
3. ROT13 (Rotate lower, Rotate upper, 7) ➡ **ROT13 (Rotate lower, Rotate upper, -7)**
4. Split (H0, H0\n) ➡ **Find / Replace (H0\n, H0)**
5. Jump (encoder1, 8) ➡ **Label (encoder1)**
6. Fork (\n, \n) ➡ **Merge All**
7. Zlib deflate (Dynamic Huffman Coding) ➡  **Zlib inflate (0, 0, Adaptive)**
8. Xor (h0pp3r, UTF8, Standard) ➡ **Xor (symmetical)**
9. To Base32 (A-Z2-7=) ➡ **From Base32 (A-Z2-7=)**
10. Merge All ➡ **Fork (\n, \n)**


## apply the fx in reverse

From the bottom to the top - [recipe here](https://gchq.github.io/CyberChef/#recipe=Fork('%5C%5Cn','%5C%5Cn',false)From_Base32('A-Z2-7%3D',true)XOR(%7B'option':'UTF8','string':'h0pp3r'%7D,'Standard',false)Zlib_Inflate(0,0,'Adaptive',false,false)Merge(true)Label('encoder1')Find_/_Replace(%7B'option':'Regex','string':'H0%5C%5Cn'%7D,'H0',true,false,false,false)ROT13(true,true,false,-7)Jump('encoder1',8)From_Base64('A-Za-z0-9%2B/%3D',false,false)&oeol=CR)

The download file is a png showing the text `one_hopper_army`.

That's likely it, as it was for sq1.png in [thm-aoc2025-side-quest-01a.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-01a.md)

## next step

➡ "Carrotbane of My Existence" [thm-aoc2025-side-quest-03b.md](https://github.com/TurboLabIt/cybersec/blob/main/notes/thm-aoc2025-side-quest-03b.md)
