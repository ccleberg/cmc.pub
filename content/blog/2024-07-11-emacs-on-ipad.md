+++
date = 2024-07-11T20:24:02
title = "Emacs on iPadOS"
description = "Learn how to install and use Emacs on the Apple Silicon iPad natively."
draft = true
+++

This post describes the process to install and use Emacs on the iPad Air 13-inch 
(M2). The iPad used in this post is running iPadOS 17.6.

## Shell Application

In order to use Emacs on an iPad, you will need a terminal emulator application. 
I recommend [iSH](https://apps.apple.com/us/app/ish-shell/id1436902243), since 
it runs a version of Alpine Linux within the app itself and will allow you to 
install packages that you need.

![iSH App](https://img.cleberg.net/blog/20240711-emacs-on-ipad/)

## Require Packages

I started by adding the required packages directly within iSH. Emacs should 
install dependencies by default, but I include a few other packages that I use 
in my terminal as well.

```sh
apk add emacs ripgrep fd findutils
```

![Package Installation](https://img.cleberg.net/blog/20240711-emacs-on-ipad/)

## Emacs

Once this is complete, you should be able to run Emacs natively on your iPad. 
It's fairly effective, but can be slow at times.

I attempted to also install Doom Emacs, which technically worked, but was so 
incredibly slow and buggy that I was not even able to take screenshots. Someone 
smarter than me could likely get it to work with a little tinkering.

![Emacs](https://img.cleberg.net/blog/20240711-emacs-on-ipad/)

### Annoyances

While Emacs is running at this point, it's not perfect. There is no `.emacs` 
file by default, installing a framework like Doom seemed to be too much, and 
some utilities and packages are missing from the bare Alpine installation.

There also seems to be a problem getting a wider selection of packages from 
MELPA, but you can see below that a handful of readily-available packages. I 
likely just need to change my configuration for MELPA, but I did not explore 
this area further.

You can test this out yourself with `M-x package-install <search-termœ>`.

![package-install](https://img.cleberg.net/blog/20240711-emacs-on-ipad/)
