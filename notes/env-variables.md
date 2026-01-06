## direct .env access

For PHP application, try to access the `../.env` or `../.env.local.php` file directly.

If the file exists, it's always readable.


## /proc/self/environ

A virtual file in Linux that contains the initial environment variables for the **process** that is currently accessing the file.

The file *should* be readable (`sudo -u www-data -H cat /proc/self/environ` works), but via php-fpm I got:

> Warning: file_get_contents(/proc/self/environ): Failed to open stream: Permission denied

This is likely due to some kind of hardening.

`open_basedir()` can also help, if configured explicitly:

> Warning: file_get_contents(): open_basedir restriction in effect. File(/proc/self/environ) is not within the allowed path(s):
