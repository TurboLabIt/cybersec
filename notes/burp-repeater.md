## setup

[Install Burp and FoxyProxy](https://github.com/TurboLabIt/cybersec/blob/main/notes/burp-foxyproxy.md)


## start

Run Burp -> `Temporary project in memory -> Use Burp defaults`.


## capture the payload

`Proxy -> Intercept -> Enable` (if shown). Then `Intercept: OFF`.

Try to browse. `Proxy -> HTTP history` should show the requests.

Rclick on the request -> `Send to repeater`.


## flood

The repeater show a copy of the request.

Rclick on the tab -> `Add tab to group`.

Rclick on the request tab -> `Duplicate tab`.

Chevron-down on the `Send` button -> `Send group in parallel` -> `Send`.


## to slightly modify each request

Rclick on the request -> `Send to repeater`.

`Add §` adds the placeholder for the actual value.

Using the `Payload` sidebar you can either add a numeric counter (from...to) or a list of values.

`Start attack` sends the requests.
