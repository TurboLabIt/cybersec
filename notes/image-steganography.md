## format check

Make sure the file is actual image:

````shell
$ file sq1.png
sq1.png: PNG image data, 668 x 936, 8-bit/color RGBA, non-interlaced
````


## metadata

Look for `Description`, `Comment`, or custom XMP tags.

````shell
$ exiftool sq1.png

ExifTool Version Number         : 13.36
File Name                       : sq1.png
Directory                       : .
File Size                       : 421 kB
...
File Permissions                : -rwxrwxr-x
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Image Width                     : 668
Image Height                    : 936
Bit Depth                       : 8
Color Type                      : RGB with Alpha
Compression                     : Deflate/Inflate
Filter                          : Adaptive
Interlace                       : Noninterlaced
Image Size                      : 668x936
Megapixels                      : 0.625
````


## Appended Data (EOF Steganography)

PNG files end with a specific "End-of-Image" chunk: IEND (hex: 49 45 4e 44 ae 42 60 82).
Anything after this signature is ignored by viewers but can contain hidden messages or even a .zip file.

`strings sq1.png | tail`


## zsteg (PNG & BMP)

[zed-0xff/zsteg](https://github.com/zed-0xff/zsteg)

> detect stegano-hidden data in PNG & BMP

Install:

````shell
sudo gem install zsteg
````

Use it:

````shell
zsteg -a image.png
````


## stegseek

````shell
$ stegseek data/image-with-seghide.jpg /usr/share/wordlists/rockyou.txt

StegSeek 0.6 - https://github.com/RickdeJager/StegSeek

[i] Found passphrase: "admin"
[i] Original filename: "note.txt".
[i] Extracting to "data/image-with-seghide.jpg.out".
```
