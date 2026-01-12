📚 [TryHackMe W1seGuy](https://tryhackme.com/room/w1seguy)

There's a file to download: `source-1705339805281.py`.

The brief states:

> crypto challenge

The same file is running on the target (port 1337).

We can interact with it via nc.


## code inspection

````py
def setup(server, key):
    flag = 'THM{thisisafakeflag}' 
    xored = ""

    for i in range(0,len(flag)):
        xored += chr(ord(flag[i]) ^ ord(key[i%len(key)]))

    hex_encoded = xored.encode().hex()
    return hex_encoded

def start(server):
    res = ''.join(random.choices(string.ascii_letters + string.digits, k=5))
    key = str(res)
    hex_encoded = setup(server, key)
    send_message(server, "This XOR encoded text has flag 1: " + hex_encoded + "\n")
    
    send_message(server,"What is the encryption key? ")
    key_answer = server.recv(4096).decode().strip()
    
    ...
    
    if key_answer == key:
    send_message(server, "Congrats! That is the correct key! Here is flag 2: " + flag + "\n")
    server.close()
    
    ...
````


## recon

`nc 10.67.166.169 1337`

The server asks:

> This XOR encoded text has flag 1: <variable-text>
> What is the encryption key?


## find the encryption key

The encryption key is <variable-text-2>. Ask AI to find it.


## flag 2

Flag2 is shown on screen as soon as the encryption key is provided. Flag2 is: `THM{BrUt3_ForC1nG_XOR_cAn_B3_FuN_nO?}`


## flag 1

After we got the encryption key, use [this CyberChef recipe](https://cyberchef.io/#recipe=From_Hex('Auto')XOR(%7B'option':'UTF8','string':'Zv2mA'%7D,'Standard',false)&input=MGUzZTdmMTYzMTZiMTc1ZTAzMzUxZjBlNDYyYzM1MmU0MjUxMDYyMjFiMTg0MDVlMjAzNjNhNGIwNTE0MjgwMjRiNWQzNDI4MGU3ZDFmM2M) to decode it:

1. from hex (Auto)
2. XOR (UTF-8, standard)

The first flag is: `THM{p1alntExtAtt4ckcAnr3alLyhUrty0urxOr}`.
