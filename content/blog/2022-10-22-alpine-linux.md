+++
date = 2022-10-22
title = "Alpine Linux: My New Server OS"
description = ""
draft = false
+++

# Alpine Linux

[Alpine Linux](https://alpinelinux.org) is a very small distro, built on
musl libc and busybox. It uses ash as the default shell, OpenRC as the
init system, and apk as the package manager. According to their website,
an Alpine container \"requires no more than 8 MB and a minimal
installation to disk requires around 130 MB of storage.\" An actual bare
metal machine is recommended to have 100 MB of RAM and 0-700 MB of
storage space.

Historically, I\'ve used Ubuntu\'s minimal installation image as my
server OS for the last five years. Ubuntu worked well and helped as my
original server contained an nVidia GPU and no onboard graphics, so
quite a few distros won\'t boot or install without a lot of tinkering.

Alpine has given me a huge increase in performance across my Docker apps
and Nginx websites. CPU load for the new server I\'m using to test
Alpine hovers around 0-5% on average with an Intel(R) Core(TM) i3-6100
CPU @ 3.70GHz.

The only services I haven\'t moved over to Alpine are Plex Media Server
and Syncthing, which may increase CPU load quite a bit depending on how
many streams are running.

## Installation

In terms of installation, Alpine has an incredibly useful
[wiki](https://wiki.alpinelinux.org/wiki/Installation) that will guide a
user throughout the installation and post-installation processes, as
well as various other articles and guides.

To install Alpine, find an appropriate [image to
download](https://alpinelinux.org/downloads/) and flash it to a USB
using software such as Rufus or Etcher. I opted to use the Standard
image for my x86~64~ architecture.

Once the USB is ready, plug it into the machine and reboot. Note that
you may have to use a key such as `Esc` or `F1-12`
to access the boot menu. The Alpine Linux terminal will load quickly and
for a login.

To log in to the installation image, use the `root` account;
there is no password. Once logged-in, execute the setup command:

```sh
setup-alpine
```

The setup script will ask a series of questions to configure the system.
Be sure to answer carefully or else you may have to re-configure the
system after boot.

-   Keyboard Layout (Local keyboard language and usage mode, e.g., us
    and variant of us-nodeadkeys.)
-   Hostname (The name for the computer.)
-   Network (For example, automatic IP address discovery with the
    \"DHCP\" protocol.)
-   DNS Servers (Domain Name Servers to query. For privacy reasons, it
    is NOT recommended to route every local request to servers like
    Google\'s 8.8.8.8 .)
-   Timezone
-   Proxy (Proxy server to use for accessing the web. Use \"none\" for
    direct connections to the internet.)
-   Mirror (From where to download packages. Choose the organization you
    trust giving your usage patterns to.)
-   SSH (Secure SHell remote access server. \"Openssh\" is part of the
    default install image. Use \"none\" to disable remote login, e.g. on
    laptops.)
-   NTP (Network Time Protocol client used for keeping the system clock
    in sync with a time-server. Package \"chrony\" is part of the
    default install image.)
-   Disk Mode (Select between diskless (disk=\"none\"), \"data\" or
    \"sys\", as described above.)

Once the setup script is finished, be sure to reboot the machine and
remove the USB device.

```sh
reboot
```

## Post-Installation

There are many things you can do once your Alpine Linux system is up and
running, and it largely depends on what you\'ll use the machine for.
I\'m going to walk through my personal post-installation setup for my
web server.

1.  Upgrade the System

    First, login as `root` in order to update and upgrade the
    system:

    ```sh
    apk -U upgrade
    ```

2.  Adding a User

    I needed to add a user so that I don\'t need to log in as root. Note
    that if you\'re used to using the `sudo` command, you
    will now need to use the `doas` command on Alpine Linux.

    ```sh
    apk add doas
    adduser <username>
    adduser <username> wheel
    ```

    You can now log out and log back in using the newly-created user:

    ```sh
    exit
    ```

3.  Enable Community Packages

    In order to install more common packages that aren\'t found in the
    `main` repository, you will need to enable the
    `community` repository:

    ```sh
    doas nano /etc/apk/repositories
    ```

    Uncomment the community line for whichever version of Alpine you\'re
    running:

    ```sh
    /media/usb/apks
    http://dl-cdn.alpinelinux.org/alpine/v3.16/main
    http://dl-cdn.alpinelinux.org/alpine/v3.16/community
    #http://dl-cdn.alpinelinux.org/alpine/edge/main
    #http://dl-cdn.alpinelinux.org/alpine/edge/community
    #http://dl-cdn.alpinelinux.org/alpine/edge/testing
    ```

4.  Install Required Packages

    Now that the community packages are available, you can install any
    packages you need. In my case, I installed the web server packages I
    need for my services:

    ```sh
    doas apk add nano nginx docker docker-compose ufw
    ```

5.  SSH

    If you didn\'t install OpenSSH as part of the installation, you can
    do so now:

    ```sh
    doas apk add openssh
    ```

    Next, either create a new key or copy your SSH key to the server
    from your current machines:

    ```sh
    # Create a new key
    ssh-keygen
    ```

    If you need to copy an existing SSH key from a current machine:

    ```sh
    # Copy key from existing machines
    ssh-copy-id <username>@<ip_address>
    ```

6.  Firewall

    Lastly, I installed `ufw` above as my firewall. To set
    up, default to deny incoming and allow outgoing connections. Then
    selectively allow other ports or apps as needed.

    ```sh
    doas ufw default deny incoming
    doas ufw default allow outgoing
    doas ufw allow SSH
    doas ufw allow "WWW Full"
    doas ufw allow 9418 # Git server port
    ```

7.  Change Hostname

    If you don\'t like the hostname set during installation, you just
    need to edit two files. First, edit the simple hostname file:

    ```sh
    doas nano /etc/hostname
    ```

    ```sh
    <hostname>
    ```

    Next, edit the `hosts` file:

    ```sh
    doas nano /etc/hosts
    ```

    ```sh
    127.0.0.1   <hostname>.local <hostname> localhost.local localhost
    ::1         <hostname> <hostname>.local
    ```

# Nginx Web Server

To set up my web server, I simply created the `www` user and
created the necessary files.

```sh
doas adduser -D -g 'www' www
mkdir /www
doas mkdir /www
doas chown -R www:www /var/lib/nginx/
doas chown -R www:www /www
```

If you\'re running a simple webroot, you can alter the main
`nginx.conf` file. Otherwise, you can drop configuration
files in the following directory. You don\'t need to enable or symlink
the configuration file like you do in other systems.

```sh
doas nano /etc/nginx/http.d/example_website.conf
```

Once the configuration is set and pointed at the `/www`
directory to serve files, enable the Nginx service:

```sh
# Note that 'default' must be included or Nginx will not start on boot
doas rc-update add nginx default
```

# Docker Containers

Docker works exactly the same as other systems. Either execute a
`docker run` command or create a
`docker-compose.yml` file and do
`docker-compose up -d`.

# Git Server

I went in-depth on how to self-host a git server in another post:
[Self-Hosting a Personal Git Server](../git-server/).

However, there are a few differences with Alpine. First note that in
order to change the `git` user\'s shell, you must do a few
things a little different:

```sh
doas apk add libuser
doas touch /etc/login.defs
doas mkdir /etc/default
doas touch /etc/default/useradd
doas lchsh git
```

# Thoughts on Alpine

So far, I love Alpine Linux. I have no complaints about anything at this
point, but I\'m not completely finished with the migration yet. Once
I\'m able to upgrade my hardware to a rack-mounted server, I will
migrate Plex and Syncthing over to Alpine as well - possibly putting
Plex into a container or VM.

The performance is stellar, the `apk` package manager is
seamless, and system administration tasks are effortless. My only regret
is that I didn\'t install Alpine sooner.
