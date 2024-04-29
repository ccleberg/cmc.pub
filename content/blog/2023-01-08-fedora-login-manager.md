+++
date = 2023-01-08
title = "How to Remove the Login Manager from Fedora i3"
description = ""
draft = false
+++

# Fedora i3's Login Manager

Since I use the i3 spin of Fedora Workstation, I don't like to have a login
manager installed by default. As of the current version of Fedora i3, the
default login manager is LightDM.

If this is no longer the case, you can search for currently-installed packages
with the following command and see if you can identify a different login
manager.

```sh
sudo dnf list installed
```

# Removing the Login Manager

In order to remove the login manager, simply uninstall the package.

```sh
sudo dnf remove lightdm
```

# Launching i3 Manually

In order to launch i3 manually, you need to set up your X session properly. To
start, create or edit the `~/.xinitrc` file to include the following at the
bottom.

``` config
exec i3
```

Now, whenever you log in to the TTY, you can launch your desktop with the
following command.

```sh
startx
```
