+++
date = 2022-12-23
title = "Alpine Linux as a Desktop OS"
description = ""
draft = false
+++

# Isn't Alpine Linux for Servers?

This is a question I see a lot when people are presented with an example of
Alpine Linux running as a desktop OS.

While Alpine is small, fast, and minimal, that doesn't stop it from functioning
at a productive level for desktop users.

This post is documentation of how I installed and modified Alpine Linux to
become my daily desktop OS.

# Installation

Note that I cover the installation of Alpine Linux in my other post, so I won't
repeat it here: [Alpine Linux: My New Server OS](../alpine-linux/).

Basically, get a bootable USB or whatever you prefer with Alpine on it, boot the
ISO, and run the setup script.

```sh
setup-alpine
```

Once you have gone through all the options and installer finishes without
errors, reboot.

```sh
reboot
```

# Initial Setup

Once Alpine is installed and the machine has rebooted, login is as root
initially or `su` to root once you log in as your user. From here, you should
start by updating and upgrading the system in case the ISO was not fully
up-to-date.

```sh
# Update and upgrade system
apk -U update && apk -U upgrade

# Add an editor so we can enable the community repository
apk add nano
```

You need to uncomment the `community` repository for your version of Alpine
Linux.

For v3.17, the `repositories` file should look like this:

```sh
nano /etc/apk/repositories
```

```conf
#/media/sda/apks
http://mirrors.gigenet.com/alpinelinux/v3.17/main
http://mirrors.gigenet.com/alpinelinux/v3.17/community
#http://mirrors.gigenet.com/alpinelinux/edge/main
#http://mirrors.gigenet.com/alpinelinux/edge/community
#http://mirrors.gigenet.com/alpinelinux/edge/testing
```

```sh
# Add the rest of your packages
apk add linux-firmware iwd doas git curl wget

# Add yourself to the wheel group so you can use the doas command
adduser $USER wheel
```

# Window Manager (Desktop)

The [Sway installation guide](https://wiki.alpinelinux.org/wiki/Sway) has
everything you need to get Sway working on Alpine.

However, I'll include a brief list of the commands I ran and their purpose for
posterity here.

```sh
# Add eudev and set it up
apk add eudev
setup-devd udev

# Since I have Radeon graphics, I need the following packages
apk add mesa-dri-gallium mesa-va-gallium

# Add user to applicable groups
adduser $USER input
adduser $USER video

# Add a font package
apk add ttf-dejavu

# Add the seatd daemon
apk add seatd
rc-update add seatd
rc-service seatd start

# Add user to seat group
adduser $USER seat

# Add elogind
apk add elogind polkit-elogind
rc-update add elogind
rc-service elogind start

# Finally, add sway and dependencies
apk add sway sway-doc
apk add                \ # Install optional dependencies:
    xwayland             \ # recommended for compatibility reasons
    foot                 \ # default terminal emulator
    bemenu               \ # wayland menu
    swaylock swaylockd   \ # lockscreen tool
    swaybg               \ # wallpaper daemon
    swayidle               # idle management (DPMS) daemon
```

Once you have the packages installed and set-up, you need to export the
`XDG_RUNTIME_DIR` upon login. To do this, edit your `.profile` file.

If you use another shell, such as `zsh`, you need to edit that shell's profile
(e.g., `~/.zprofile`)!

```sh
nano ~/.profile
```

Within the file, paste this:

```sh
if test -z "${XDG_RUNTIME_DIR}"; then
  export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
  if ! test -d "${XDG_RUNTIME_DIR}"; then
    mkdir "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi
```

Once that's complete, you can launch Sway manually.

```sh
dbus-run-session -- sway
```

## Personal Touches

I also added the following packages, per my personal preferences and situation.

```sh
doas apk add brightnessctl   \ # Brightness controller
             zsh             \ # Shell
             firefox         \ # Browser
             syncthing       \ # File sync service
             wireguard-tools \ # Wireguard VPN
             gomuks          \ # CLI Matrix client
             neomutt         \ # CLI email client
             thunderbird     \ # GUI email client
             gnupg             # GPG key manager
```

From here, I use my Syncthing storage to pull all the configuration files I
stored from prior desktops, such as [my
dotfiles](https://git.sr.ht/~cmc/dotfiles).

# Resolving Issues

## WiFi Issues

I initially tried to set up my Wi-Fi the standard way with `iwd`, but it didn't
work.

Here is what I initially tried (I did all of this as `root`):

```sh
apk add iwd
rc-service iwd start
iwctl station wlan0 connect <SSID> # This will prompt for the password
rc-update add iwd boot && rc-update add dbus boot
```

Then, I added the Wi-Fi entry to the bottom of the networking interface file:

```sh
nano /etc/network/interfaces
```

```conf
auto wlan0
iface wlan0 inet dhcp
```

Finally, restart the networking service:

```sh
rc-service networking restart
```

My Wi-Fi interface would receive an IP address from the router, but it could not
ping anything in the network. To solve the Wi-Fi issues, I originally upgraded
to Alpine's `edge` repositories, which was unnecessary.

Really, the solution was to enable the `NameResolvingService=resolvconf` in
`/etc/iwd/main.conf`.

```sh
doas nano /etc/iwd/main.conf
```

```conf
[Network]

NameResolvingService=resolvconf
```

Once I finished this process, my Wi-Fi is working flawlessly.

## Sound Issues

Same as with the Wi-Fi, I had no sound and could not control the mute/unmute or
volume buttons on my laptop.

To resolve this, I installed
[pipewire](https://wiki.alpinelinux.org/wiki/PipeWire).

```sh
# Add your user to the following groups
addgroup $USER audio
addgroup $USER video

# Install pipewire and other useful packages
apk add pipewire wireplumber pipewire-pulse pipewire-jack pipewire-alsa
```

Finally, I needed to add `/usr/libexec/pipewire-launcher` to my
`.config/sway/config` file so that Pipewire would run every time I launched
sway.

```sh
nano ~/.config/sway/config
```

```conf
# Run pipewire audio server
exec /usr/libexec/pipewire-launcher

# Example audio button controls
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle
```

Note that I do not use bluetooth or screen sharing, so I won't cover those
options in this post.

Other than these issues, I have a working Alpine desktop. No other complaints
thus far!
