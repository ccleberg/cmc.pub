+++
date = 2022-09-17
title = "Serenity OS: Testing Out a Unique System"
description = ""
draft = false
+++

# Overview

[SerenityOS](https://serenityos.org) is a unique operating system (OS) that I
have seen pop up in my news feed a few times over the last few years, but I have
never had time to test it out until now.

Testing out this system brought back fond memories of yellowed,
modem-screeching, 100-pound computers that brought so many fond memories to my
youth.

Per their website:

> A graphical Unix-like operating system for desktop computers!
>
> SerenityOS is a love letter to '90s user interfaces with a custom Unix-like
> core. It flatters with sincerity by stealing beautiful ideas from various
> other systems.
>
> Roughly speaking, the goal is a marriage between the aesthetic of late-1990s
> productivity software and the power-user accessibility of late-2000s *nix.
>
> This is a system by us, for us, based on the things we like.

# Building

Your first question may be "Where's the iso?" and the answer is... there are
none. SerenityOS does not provide pre-built images for testing. You must build
the images yourself. This seems intentionally to limit participation to only
those who are truly interested enough to learn how to build the OS.

## Clone

In order to get started, you'll need to clone the source repository:

```sh
git clone https://github.com/SerenityOS/serenity && cd serenity
```

## Build

Note that I followed the [Build
Instructions](https://github.com/SerenityOS/serenity/blob/master/Documentation/BuildInstructions.md)
in the SerenityOS repository as of commit
`660d2b53b1206e868d5470eee80b5e62d7e30da7`. Things may have changed since my
installation, and you should double-check the instructions first.

Regardless, I want to repeat my steps here to illustrate any errors or differing
commands I needed to run in order to build and run SerenityOS.

Since I am running Fedora, I needed to install these packages in order to build
the OS images:

```sh
sudo dnf install texinfo binutils-devel curl cmake mpfr-devel libmpc-devel gmp-devel e2fsprogs ninja-build patch ccache rsync @"C Development Tools and Libraries" @Virtualization
```

Next, make sure you're inside the `serenity` directory created earlier during
the git cloning process and process to build the toolchain:

```sh
Meta/serenity.sh rebuild-toolchain
```

Once the toolchain is built, you can Build and run the OS!

```sh
Meta/serenity.sh run
```

After this process is completed, the image should run automatically and launch.

# Issues

I played around in SerenityOS for an hour or two in order to see what I could do
and had a lot of fun with it. The only issue I ran into was a lack of working
internet. I didn't try very hard, but I could tell that the main network link
wasn't connecting to my Fedora host properly.

# Screenshots

The initial launch of the image displays the SerenityOS desktop, with a simple
terminal already launched:

![SerenityOS
Terminal](https://img.cleberg.net/blog/20220917-serenityos/initial_launch.png)

Here you can see the Fire application (literally just shows fire burning), a
browser with the local Serenity Browser page loaded, and a text editor.

![SerenityOS
Fire](https://img.cleberg.net/blog/20220917-serenityos/basic_apps.png)

I also poked around the system utilities and found most tools you'd expect to
find within a standard desktop.

![SerenityOS System
Monitor](https://img.cleberg.net/blog/20220917-serenityos/system_monitor.png)

Lastly, I noted that the default desktop contains numerous pre-defined themes to
choose from. This is a small piece, but it's actually wonderful to see desktop
developers consider theming directly out of the box rather than using an
addon-based mentality.

![SerenityOS
Themes](https://img.cleberg.net/blog/20220917-serenityos/themes.png)

I didn't take a screenshot of the other pre-installed games, but I did spend
nearly 30 minutes playing Solitaire before remembering that I was supposed to be
writing a post about the OS.
