+++
date = 2023-01-21
title = "Running Flatpak Apps with Symlinks"
description = ""
draft = false
+++

# Running Flatpak Apps Should Be Faster

If you\'re like me and use Flatpak for those pesky apps that cannot run
on your system for one reason or another, you likely get annoyed with
opening a terminal and manually running the Flatpak app with the lengthy
`flatpak run ...` command.

In the past, I manually created aliases in my `.zshrc` file
for certain apps. For example, an alias would look like the example
below.

This would allow me to run the command fast within the terminal, but it
wouldn\'t allow me to run it in an application launcher.

```sh
# ~/.zshrc
alias librewolf = "flatpak run io.gitlab.librewolf-community"
```

However, I now use a much faster and better method that integrates with
the tiling WMs I use and their application launchers -
`dmenu` and `bemenu`.

# Creating Symlinks for Flatpak Apps

Let\'s use the example of Librewolf below. I can install the application
like so:

```sh
flatpak install flathub io.gitlab.librewolf-community
```

Once installed, I can create a symlink to link the flatpak app to my new
symlink in a location commonly included in your PATH. In this case, I
chose `/usr/bin`. You may need to choose a different location
if `/usr/bin` isn\'t in your PATH.

```sh
ln -s /var/lib/flatpak/exports/bin/io.gitlab.librewolf-community /usr/bin/librewolf
```

Once complete, you should be able to launch the app using the command
name you chose above in the symlink (`librewolf`) from a
terminal or from your application launcher!
