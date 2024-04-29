+++
date = 2024-01-09
title = "Customizing macOS"
description = ""
draft = false
+++

I have been using macOS more than Linux lately, so I wrote this post to describe
some simple options to customize macOS beyond the normal built-in settings menu.

While not all-encompassing, the options below should be a good start for anyone
looking to dive down the rabbit hole.

# Basics

## Package Management

To install a lot of software on macOS, you will need
[Homebrew](https://brew.sh/). You can use their installation script to get
started. Simply open the `Terminal` application and paste the following snippet:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This will allow you to easily install and manage applications and other software
easily through the `brew` command.

## Terminal

If you're serious about customizing your macOS system, I highly recommend
installing a terminal emulator that you like and if you're not comfortable on
the command line yet, start learning. A lot of customization options require you
to edit hidden files, which is easiest in a terminal.

There are options like iTerm2, Kitty, Alacritty, Hyper, Warp, or the built-in
Terminal app.

I use [iTerm2](https://iterm2.com/), which can be installed with Homebrew:

```sh
brew install iterm2
```

![iTerm2](https://img.cleberg.net/blog/20240109-macos-customization/iterm2.png)

To install color schemes, such as the Dracula scheme shown in the screenshot
above, you visit [iTerm Themes](https://iterm2colorschemes.com/) and follow
their installation instructions to install any of the themes.

# Desktop

## Window Management

[yabai](https://github.com/koekeishiya/yabai) is a tiling window manager for
macOS. While other window managers exist, I found that most of them struggled to
create logical layouts and to allow me to easily move windows around the screen.

Some advanced settings for yabai are only available if partially disable System
Integrity Protection (SIP). However, I chose not to do this and it hasn't
affected my basic usage of yabai at all.

Refer to the [yabai
wiki](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release))
for installation instructions. You will need to ensure that yabai is allowed to
access the accessibility and screen recording APIs.

You can see a basic three-pane layout atuomatically configured by yabai for me
as I opened the windows below.

![yabai window
manager](https://img.cleberg.net/blog/20240109-macos-customization/yabai.png)

## Keyboard Shortcuts

[skhd](https://github.com/koekeishiya/skhd) is a simple hotkey daemon that
allows you to define hotkeys in a file for usage on your system.

Installation is simple:

```sh
brew install koekeishiya/formulae/skhd
skhd --start-service
```

After installation, be sure to allow `skhd` access to the accessibility API in
the macOS privacy settings.

You can configure your hotkeys in the `~/.config/skhd/skhdrc` file:

```sh
nano ~/.config/skhd/skhdrc
```

For example, I have hotkeys to open my browser and terminal:

``` conf
# Terminal
cmd - return : /Applications/iTerm.app/Contents/MacOS/iTerm2

# Browser
cmd + shift - return : /Applications/LibreWolf.app/Contents/MacOS/librewolf
```

## Widgets

[uebersicht](https://github.com/felixhageloh/uebersicht/) is a handy
desktop-based widget tool with a plethora of community-made widgets available in
the [widgets gallery](https://tracesof.net/uebersicht-widgets/). You can also
write your own widgets with this tool.

To install, simply download the latest release from the [uebersicht
website](https://tracesof.net/uebersicht/) and copy it to the Applications
folder.

See below for an example of the
[Mond](https://tracesof.net/uebersicht-widgets/#Mond) widget in action.

![uebersicht desktop
widgets](https://img.cleberg.net/blog/20240109-macos-customization/uebersicht.png)

## Status Bar

[SketchyBar](https://github.com/FelixKratz/SketchyBar) is a customizable
replacement for the macOS status or menu bar.

You can browse a discussion where various users shared their
[configurations](https://github.com/FelixKratz/SketchyBar/discussions/47?sort=top)
for inspiration or to copy their dotfiles.

See below for a quick (& slightly broken) copy of
[zer0yu's](https://github.com/zer0yu/dotfiles) SketchyBar configuration.

![SketchyBar](https://img.cleberg.net/blog/20240109-macos-customization/sketchybar.png)

## Dock

The easiest way to customize the dock is to install
[uBar](https://ubarapp.com/), which uses a Windows-like menu bar as the default
style.

However, the built-in macOS dock cannot be disabled and can only be set to
"always hidden". This can be annoying as it will pop out any time your mouse
cursor passes closely to the dock edge of the screen. Because of this, I simply
use the built-in dock instead of customizing it with third-party software.

Regardless, see below for the default installation style of uBar.

![uBar](https://img.cleberg.net/blog/20240109-macos-customization/ubar.png)

## Application Icons

You can also customize the icon of any application in macOS, which will show up
in Finder, the Dock, Launchpad, search results, etc. I recommend using
[macOSicons](https://macosicons.com/) to download icons you want, and then apply
them by following this process.

1. Open the Finder application.
2. Navigate to the `Applications` folder.
3. Right-click an application of your choice, and select `Get Info`.
4. Drag the image you downloaded on top of the application's icon at the top of
   information window (you will see a green "plus" symbol when you're
   hovering over it).
5. Release the new icon on top of the old icon and it will update!

You can see an example of me dragging a new `signal.icns` file onto my
Signal.app information window to update it below:

![replace macOS
icons](https://img.cleberg.net/blog/20240109-macos-customization/replace_icon.png)
