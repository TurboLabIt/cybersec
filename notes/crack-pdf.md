## Crack PDFs with PDFcrack

````shell
pdfcrack -f flag.pdf -w /usr/share/wordlists/rockyou.txt
````


## Crack PDFs with John The Ripper

Install:

````shell
sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/cybersec/master/script/john-the-ripper/install.sh | sudo bash
````

Convert and crack:

````shell
pdf2john flag.pdf > flag.pdf.john
john --wordlist=/usr/share/wordlists/rockyou.txt flag.pdf.john
````
