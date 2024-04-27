+++
date = 2022-10-04
title = "Syncthing: A Minimal Self-Hosted Cloud Storage Solution"
description = ""
draft = false
+++

# An Overview of Syncthing

If you\'ve been looking around the self-hosted cloud storage space for a
while, you\'ve undoubtedly run into someone suggesting
[Syncthing](https://syncthing.net) as an option. However, it is an
unusual alternative for those users out there who are used to having a
centralized cloud server that serves as the \"controller\" of the data
and interacts with clients on devices to fetch files.

This post is a walkthrough of the Syncthing software, how I set up my
personal storage, and some pros and cons of using the software.

# Installing Syncthing

To install Syncthing, visit the
[Downloads](https://syncthing.net/downloads/) page or install via your
device\'s package manager.

## Server & Desktop

You can install Syncthing on servers and desktops via the Downloads page
linked above or via the command-line.

For Debian-based distros:

```sh
sudo apt install syncthing
```

For Fedora-based distros:

```sh
sudo dnf install syncthing
```

## Mobile

Syncthing for Android is available on
[F-Droid](https://f-droid.org/packages/com.nutomic.syncthingandroid/)
and [Google
Play](https://play.google.com/store/apps/details?id=com.nutomic.syncthingandroid).
Syncthing does not have an official iOS client, but there is a
third-party client called [Möbius
Sync](https://apps.apple.com/us/app/m%C3%B6bius-sync/id1539203216).

# How Does Syncthing Work?

To start, I wanted to include the main marketing blurb from their
website:

> Syncthing is a continuous file synchronization program. It
> synchronizes files between two or more computers in real time, safely
> protected from prying eyes. Your data is your data alone, and you
> deserve to choose where it is stored, whether it is shared with some
> third party, and how it\'s transmitted over the internet.

Let\'s break this apart and add in some other details to help explain
what exactly Syncthing does in order to sync files between devices.

## Local Syncthing Server(s)

Syncthing syncs files between multiple devices by creating a local
server on each device. These local servers handle a few different
things, such as watching files and directories for changes, hosting an
administrative GUI website, and authenticating with connected devices.

You can also start, stop, and restart the Syncthing server via the
command-line or web dashboard. If you\'re running Syncthing on a device
with `systemd`, you can use the following commands:

```sh
sudo systemctl start syncthing@username.service
sudo systemctl restart syncthing@username.service
sudo systemctl stop syncthing@username.service
```

## Syncthing Dashboard

This biggest part of Syncthing is the admin GUI website that runs on
each device (note that mobile devices will use the Syncthing app rather
than the web GUI). The admin GUI is available through the web browser on
the local device that is running Syncthing - simply go to
`http://localhost:8384` or
`http://127.0.0.1:8384`. This web page is the place where you
will change settings, add/modify synced files, and add/modify connected
devices.

Here\'s an example web GUI dashboard:

![Syncthing
Dashboard](https://img.cleberg.net/blog/20221020-syncthing/syncthing_gui.png)

## Remote Devices

A cloud storage solution wouldn\'t be very useful if you aren\'t able to
share data among various devices. Syncthing does this by sharing Device
IDs to connect servers, and then by manually sharing Folders with
devices that have been connected.

For instance, if you have a laptop running Syncthing and then install
the Syncthing mobile app on a phone, you could scan the laptop\'s QR
code for Device ID and then accept the authentication on the laptop\'s
dashboard. Next, you can use either device to select a folder for
sharing and dictating which device should send, receive, or both.

When you connect devices, you can set one device as an \"Introducer,\"
which can add devices from the introducer to the device list, for
mutually shared folders. You can also configure Auto Accept,
compression, rate limits, and more settings per device.

# My Personal Cloud Storage Set-up

Personally, I use a model similar to a traditional cloud storage
service. I have a \"centralized\" server running 24/7 that acts as an
Introducer for my Syncthing network. I think of this as my main storage
and all other devices as tertiary client devices. I will likely add
additional servers as backups as time goes on so that I don\'t have to
rely on my laptop or phone as the only backups.

Currently, I have one desktop and one mobile device connected to the
network, both running intermittently as they are not powered-on 24/7.

The initial set-up of the software was easy enough, but data transfer
rates were incredibly slow for me due to the Wi-Fi. Instead, I plugged
my laptop into the ethernet network that my server is on and manually
copied my folders over to the server with `scp`. Once
complete, Syncthing validated that all files were there and not missing,
and it did not need to transfer any data through the WAN.

As slow as the transfer was going, this probably saved me a few days of
waiting for my \~100GB sync.

# Pros & Cons

I\'ve put together a short list of pros and cons for Syncthing. I
thought about my experiences with Nextcloud, WebDAV, proprietary
services (Google Drive, iCloud, etc.), and privacy-focused cloud
solutions (pCloud, Tresorit, etc.).

**Pros:**

-   I\'ve faced no data loss at all through my two-month trial run.
-   No third-parties store your data on their servers.
-   You have full control over your data and can take your data and
    leave at any time.
-   It\'s possible to encrypt client-side easily with software like
    Cryptomator.
-   No proprietary clients or mounted volumes, just plain files and
    folders.

**Cons:**

-   The learning curve is steeper than traditional cloud services and is
    focused on a technical audience.
-   If a device needs to modify files in a Folder, the devices will need
    to sync ALL files from the folder, which may be large. To avoid size
    restraints, split large folders into smaller folders for syncing.
-   Syncing can be slow due to the clients/servers initially connecting
    or re-connecting after sleeping.
-   Multiple personal devices are required and require the user to own
    or rent them as no third-party servers are involved in the storage
    of data.

Overall, I\'ve had a great experience with Syncthing so far. I\'ve had
no data loss, syncing has been quick and easy when changes are made to
files, device connections are reliable, and I love the freedom of
controlling the clients and servers as I choose.

Not to mention that I appreciate that I - or someone else - could pull
the Syncthing [source code](https://github.com/syncthing) and continue
development/support if the Syncthing Foundation decides to stop
developing the software or sells the business.
