+++
date = 2022-11-11
title = "Fixing Permission Errors in /var/lib/nginx"
description = ""
draft = false
+++

_This is a brief post so that I personally remember the solution as it has
occurred multiple times for me._

# The Problem

After migrating to a new server OS, I started receiving quite a few permission
errors like the one below. These popped up for various different websites I'm
serving via Nginx on this server, but did not prevent the website from loading.

I found the errors in the standard log file:

```sh
cat /var/log/nginx/error.log
```

```sh
2022/11/11 11:30:34 [crit] 8970#8970: *10 open() "/var/lib/nginx/tmp/proxy/3/00/0000000003" failed (13: Permission denied) while reading upstream, client: 169.150.203.10, server: cyberchef.example.com, request: "GET /assets/main.css HTTP/2.0", upstream: "http://127.0.0.1:8111/assets/main.css", host: "cyberchef.example.com", referrer: "https://cyberchef.example.com/"
```

You can see that the error is `13: Permission denied` and it occurs in the
`/var/lib/nginx/tmp/` directory. In my case, I had thousands of errors where
Nginx was denied permission to read/write files in this directory.

So how do I fix it?

# The Solution

In order to resolve the issue, I had to ensure the `/var/lib/nginx` directory is
owned by Nginx. Mine was owned by the `www` user and Nginx was not able to read
or write files within that directory. This prevented Nginx from caching
temporary files.

```sh
# Alpine Linux
doas chown -R nginx:nginx /var/lib/nginx

# Other Distros
sudo chown -R nginx:nginx /var/lib/nginx
```

You _may_ also be able to change the `proxy_temp_path` in your Nginx config, but
I did not try this. Here's a suggestion I found online that may work if the
above solution does not:

```sh
nano /etc/nginx/http.d/example.com.conf
```

```conf
server {
  ...

  # Set the proxy_temp_path to your preference, make sure it's owned by the
  # `nginx` user
  proxy_temp_path /tmp;

  ...
}
```

Finally, restart Nginx and your server should be able to cache temporary files
again.

```sh
# Alpine Linux (OpenRC)
doas rc-service nginx restart

# Other Distros (systemd)
sudo systemctl restart nginx
```
