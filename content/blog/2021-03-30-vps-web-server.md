+++
date = 2021-03-30
title = "How to Set Up a VPS Web Server"
description = ""
draft = false
+++

# Shared Hosting vs. VPS

Choosing a place to host a website is one of the most confusing decisions for
beginner web developers. Even for experienced web devs, choosing between
different forms of web hosting can be a daunting choice.

First, let's take a look at [shared web
hosting](https://en.wikipedia.org/wiki/Shared_web_hosting_service). Shared web
hosting is a product where you are purchasing a small piece of a web server that
is being shared between many websites. As a result, the cost of shared hosting
is extremely low. You won't have access to the server itself, which means you
can't install your own software on the server, such as Docker. Usually, you are
simply allowed to connect your domains to the server, set up domain security,
and other small utilities.

In contrast, a [virtual private
server](https://en.wikipedia.org/wiki/Virtual_private_server) (VPS) is a virtual
machine that replicates the environment of having a dedicated server to
yourself. You are able to control the virtual server's host names, base file
system, package manager, etc. Another great upside of a VPS is that since it's
virtual, the company providing the VPS can dynamically increase the disk size,
RAM size, or number of CPUs at any time. However, the virtual server is still
physically located on a server that is shared between multiple virtual servers.

The choice between shared hosting and VPS mostly depends on your skill level
with system administration. If you're comforting working on a server that is
mostly left up to you (or you're willing to learn), then a VPS is usually a
better option. However, shared hosting is a fantastic option for people who
don't want to have to learn how to manage their server.

# My Situation

I had used shared hosting for approximately 5 years before trying my first VPS.
I manage a homelab and have had success running a server and performing typical
sysadmin duties, but I was still hesitant to get a VPS. One fear was that I
always struggled to properly set up the networking part of a server - DNS and
hostname configurations were not my friend.

As a little bit of background, I originally used
[Siteground](https://www.siteground.com) for my initially shared hosting and
stayed on that platform for at least a year. However, the UI was clunky, and I
didn't like how they handled certain technical aspects, so I switched to
[Namecheap](https://www.namecheap.com). Namecheap was great because it is the
service I primarily use for purchasing domain names, which made it incredibly
easy to link them to my hosting service. However, it was still mediocre shared
hosting, and Namecheap is notorious for not letting you use [Let's
Encrypt](https://letsencrypt.org) to obtain free SSL/TLS certificates; Namecheap
wants to make you purchase certificates through their store.

Finally, I settled down with [iWebFusion](https://www.iwebfusion.net) for about
the last year of my shared hosting. This service was pretty great, came with
free SSL/TLS, and I never had any complaints.

However, I finally grew tired of not being able to install software on my own
web server. I wanted to be able to try out things like
[Postmill](https://postmill.xyz) or [Matrix](https://matrix.org). This is
possible with a VPS, so I decided to grab a new domain name to try it out.

# Getting Started: Buying a VPS

The first step to moving over to a VPS is (you guessed it): finding a VPS
provider. For my VPSs, I use [1984](https://1984hosting.com) and prefer their
services much more than any alternative, due to their location (Iceland), their
[privacy policy](https://1984hosting.com/GDPR/), their respect for GDPR, and the
ability to remain anonymous if you pay in Bitcoin or Monero.

[Njalla](https://njal.la) is another good, privacy-oriented option for VPS
services.

You'll have to decide what specifications you want on your VPS. For me, I only
build and deploy low-resource HTML, PHP, and Python websites. This means I can
survive on the smallest VPS: 1 CPU, 1GB of RAM, and 25GB SSD for $5.00 per
month.

As noted above, the great thing about a VPS is you can request your provider to
increase the resources at any time.

# Configuring DNS Settings

Okay, so now let's get into some actual work that has to be done to get content
moved from a shared host to a VPS. At this point, I'm assuming you have a
shared host with website content that you can still access, and you've
purchased a new VPS and can SSH into that server.

The first change is minor, but it should be done immediately in order to get
things moving: DNS settings. Go to wherever your DNS settings are handled. If
your shared host also managed your DNS settings, you'll need to first move that
DNS over to your new VPS provider. For me, I route my DNS through
[Gandi](https://www.gandi.net).

Once you know where your DNS settings are, go ahead and update the `A` records
to match the public IP address of your VPS. For example:

``` txt
A         example.com     xxx.xxx.xxx.xxx
A         subdomain       xxx.xxx.xxx.xxx
CNAME     www             example.com.
```

If you have any other records that require updates, such as MX or TXT records
for a mail server, be sure to update those accordingly. Personally, I don't
host my own mail server. I route all mail on my custom domains to
[Migadu](https://www.migadu.com). Hosting your own email server can become
complex quickly and is not for beginners.

DNS changes can take up to 48 hours to propagate, so be sure to give it some
time before assuming you've made an error.

# Server Updates and Packages

Now that the DNS settings have been changed, let's set up our server while we
wait for the DNS to propagate. First up is to ssh into your server. If you've
signed up with a service like DigitalOcean, you can add your SSH key to your
account and to your VPS droplet so that you don't need a password in order to
SSH.

```sh
ssh root@xxx.xxx.xxx.xxx
```

The VPS that is used in this blog post runs Ubuntu 20.04 with an Apache web
server. If you're working on a different operating system (OS) or want a
different web server, such as Nginx, you'll have to use different commands to
set it up.

First, let's update and upgrade our server.

**NOTE:** Since we have logged in to the server as `root` for now, we don't
need to use the `sudo` modifier before our commands.

```sh
apt update && apt upgrade -y
```

# Create A User Account

While being able to use `root` can be beneficial at times, you shouldn't use
`root` unless you have to.

So let's set up a new user in our system. The `-m` option below tells the OS to
create a home directory for the new user.

```sh
adduser USERNAME
```

Now, create a password for that user.

```sh
passwd USERNAME
```

Finally, add the user to the sudoers file, so they can perform priveleged
commands.

```sh
usermod -a -G sudo USERNAME
```

If you are using SSH keys and not passwords, you'll need to copy your SSH key
from your local machine to the VPS. If you haven't disabled password-based SSH
yet, the easiest way to do this is `ssh-copy-id` from your local computer (not
from the VPS):

```sh
ssh-copy-id testuser@xxx.xxx.xxx.xxx
```

If you've disabled password-based SSH, you'll need to manually copy your SSH
key into the `~/.ssh/authorized_keys` file.

# Install Software

Our goal here is to host a web server, so the next step is to install the Apache
web server and any other packages we need.

From this point on, I will be logged in as a user (not `root`) and will need to
use the `sudo` modifier for most commands.

```sh
sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y
sudo apt install apache2
```

If you need other language support, such as PHP, you'll need to install that
too.

```sh
sudo apt install libapache2-mod-php php-dom
sudo a2enmod php
sudo systemctl restart apache2
```

# Website Files & Folders

Next up is to create the directories for the domain(s) we want to be hosted on
this web server.

```sh
cd /var/www
sudo mkdir example.com
```

We have a folder for `example.com` now, so let's add an `index.html` file and
put it within a specific `public_html` folder. You don't need this
`public_html` if you don't want it, but it helps with organizing items related
to `example.com` that you don't want to publish to the internet.

```sh
cd example.com
sudo mkdir public_html && cd public_html
sudo nano index.html
```

You can put anything you want in this `index.html` file. If you can't think of
anything, paste this in there:

``` html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Hello, world!</title>
    </head>
    <body>
        <h1>Hello, world!</h1>
    </body>
</html>
```

If you want something to be served at `example.com/page01/file.txt`, you'll
have to create the `page01` directory under the `example.com` directory. For
example:

```sh
cd /var/www/example.com/public_html
sudo mkdir page01
sudo nano file.txt
```

# Apache Configuration

Now, let's set up the files that will tell the server where to find the files
for `example.com`. We will copy the default configuration file and create our
own.

```sh
cd /etc/apache2/sites-available
sudo cp 000-default.conf example.com.conf
sudo nano example.com.conf
```

This configuration file will have a few default lines, but you'll need to edit
it to look similar to this (settings may change based on your personal needs):

``` config
<VirtualHost *:80>
    ServerAdmin your-email@email-provider.com
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/example.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Now, enable the configuration for your new site, disable the default
configuration, and reload the web server.

```sh
sudo a2ensite example.com.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

You can always run a test to make sure no errors or warnings are found in your
configuration files.

```sh
sudo apache2ctl configtest
```

Now, restart the web server entirely. After this, you should be able to browse
to `http://example.com` and see the HTML content you provided earlier. Note that
SSL/TLS has not been enabled yet, so you won't be able to use the secure
version yet (`https://example.com`).

```sh
sudo systemctl restart apache2
```

You can repeat this for as many websites as you need. Just create the domain
folders in `/var/www/`, add the configuration file, enable the configuration,
and restart `apache2`.

# SSL/TLS Certificates: Serve Websites Over HTTPS

In order to serve secure content, you'll need to obtain SSL/TLS certificates.
Luckily, there's a free tool called [Certbot](https://certbot.eff.org) that
helps us with the process.

The first step is to install `snapd` and `core` for Ubuntu.

```sh
sudo apt install snapd
sudo snap install core
sudo snap refresh core
```

Next, install the `certbot` snap package.

```sh
sudo snap install --classic certbot
```

Execute the following command to ensure that the `certbot` command can be run.

```sh
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Finally, you can run `certbot` one of two ways:

1. run it and let it alter your Apache configuration files automatically to
   enable HTTPS redirects.
2. run it and only allow it to create certificates. You'll need to manually
   alter the config files to enable HTTPS redirects.

Run certbot and allow automatic config changes:

```sh
sudo certbot --apache
```

Run certbot for certificates only and don't allow it to alter config files:

```sh
sudo certbot certonly --apache
```

The Certbot packages on your system come with a cron job or systemd timer that
will renew your certificates automatically before they expire. You will not need
to run Certbot again unless you change your configuration. You can test
automatic renewal for your certificates by running this command:

```sh
sudo certbot renew --dry-run
```

Now, test your domains by going to `https://example.com`.

# Firewall Security

To enable better security on your server, you'll need to enable a basic
firewall. For Ubuntu, we'll use [the uncomplicated
firewall](../secure-your-network-with-the-uncomplicated-firewall/).

Now, add the following rules to the firewall allow SSH, Apache, and HTTP(S)
connections. If you need to, you can enable different ports for specifics
applications, SFTP, etc.

```sh
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow Apache
sudo ufw allow proto tcp from any to any port 80,443
```

Once you've added all the rules you need, enable the firewall.

```sh
sudo ufw enable
```

# Troubleshooting

If you run into any issues during your VPS set-up, be sure to walk back through
your actions and make sure you didn't miss any steps.

Many websites have fantastic guides to setting up various web servers. This is
one of the areas [where DigitalOcean
shines](https://www.digitalocean.%20com/community/tutorials). For simpler or
more Linux-oriented questions, I suggest using [Linuxize]
(<https://linuxize.com>).

If you're getting certain errors (e.g. `500 Internal Server Error`) and need to
debug locally, you can view the `access.log` and `error.log` files in the
`/var/log/apache/` directory.
