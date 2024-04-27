+++
date = 2022-10-30
title = "How to Disable or Change the Display Manager on Void Linux"
description = ""
draft = false
+++

# Display Manager Services

In order to change the [display
manager](https://en.wikipedia.org/wiki/Display_manager) on Void Linux -
or any other Linux distro - you need to identify the currently enabled
display manager.

## Disabling the Current Display Manager

Void Linux only has one ISO available for download with a pre-built
display manager at the time of this post: the XFCE ISO. If you\'ve
installed this version, the pre-assigned display manager is
`lxdm`. If you installed another display manager, replace
`lxdm` in the following command with the display manager you
have installed.

To disable `lxdm`, simply remove the service symlink:

```sh
sudo rm /var/service/lxdm
```

## Enabling a New Display Manager

If you want to enable a new display manager, you can do so after
`lxdm` is disabled. Make sure to replace
`<new_display_manager>` with your new DM, such as
`gdm`, `xdm`, etc.

```sh
sudo ln -s /etc/sv/<new_display_manager> /var/service
```

# Set Up `.xinitrc`

Depending on your setup, you may need to create a few X files, such as
`~/.xinitrc`. For my personal set-up, I created this file to
launch the i3wm as my desktop.

```sh
nano ~/.xinitrc
```

```sh
#!/bin/sh

exec i3
```

If you run a desktop other than i3, simply replace `i3` with
the shell command that launches that desktop.

# Set Up Your Shell Profile

Finally, in order to automatically launch an X session upon login, you
will need to edit the `.bash_profile` (bash) or
`.zprofile` (zsh) files for your shell:

```sh
nano ~/.zprofile
```

Add the following snippet to the end of the shell profile file. This
will execute the `startx` command upon login.

```sh
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
```

Alternatively, you can ignore this step and simply choose to manually
execute `startx` upon login. This can be useful if you have
issues with your desktop or like to manually launch different desktops
by choice.
