+++
date = 2023-09-15
title = "Self-Hosting Gitweb via Nginx"
description = ""
draft = false
+++

# Overview

[GitWeb](https://git-scm.com/book/en/v2/Git-on-the-Server-GitWeb) is a simple
web-based visualizer for git repositories. By default, GitWeb will only run with
the `lighttpd` or `webrick` web servers.

However, this guide will show you how to keep GitWeb running in the background
and display information for all repositories in a chosen directory.

# Install Dependencies

To start, you'll need install the following packages:

```sh
sudo apt install git gitweb fcgiwrap nginx
```

# Configure Nginx

Once installed, create an Nginx configuration file.

```sh
sudo nano /etc/nginx/sites-available/git.example.com
```

```conf
server {
        listen 80;
        server_name example.com;

        location /index.cgi {
                root /usr/share/gitweb/;
                include fastcgi_params;
                gzip off;
                fastcgi_param SCRIPT_NAME $uri;
                fastcgi_param GITWEB_CONFIG /etc/gitweb.conf;
                fastcgi_pass  unix:/var/run/fcgiwrap.socket;
        }

        location / {
                root /usr/share/gitweb/;
                index index.cgi;
        }
}
```

To make the configuration active, you need to symlink it and then restart Nginx.

```sh
sudo ln -s /etc/nginx/sites-available/git.example.com /etc/nginx/sites-enabled/git.example.com
sudo systemctl restart nginx.service
```

The GitWeb application should now be available via the URL you set in the Nginx
configuration above.

# Customize GitWeb

If you need to, you can customize many things about Gitweb by editing the
[gitweb.conf](https://git-scm.com/docs/gitweb.conf) file.

```sh
sudo nano /etc/gitweb.conf
```
