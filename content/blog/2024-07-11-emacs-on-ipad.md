+++
date = 2024-07-11T20:24:02
title = "Emacs on iPadOS"
description = "Learn how to install and use Emacs on the Apple Silicon iPad natively."
draft = false
+++

This post describes the process to install and use Emacs on the iPad Air 13-inch
(M2). The iPad used in this post is running iPadOS 17.6.

## Shell Application

In order to use Emacs on an iPad, you will need a terminal emulator application.
I recommend [iSH](https://apps.apple.com/us/app/ish-shell/id1436902243), since
it runs a version of Alpine Linux within the app itself and will allow you to
install packages that you need.

![iSH Application](https://img.cleberg.net/blog/20240711-emacs-on-ipad/ish.png)

## Require Packages

I started by adding the required packages directly within iSH. Emacs should
install dependencies by default, but I include a few other packages that I use
in my terminal as well.

```sh
apk add emacs ripgrep fd findutils
```

![Package
!Installation](https://img.cleberg.net/blog/20240711-emacs-on-ipad/dependencies.png)

## Emacs

Once this is complete, you should be able to run Emacs natively on your iPad.
It's effective, but can be slow at times.

I attempted to also install Doom Emacs, which technically worked, but was so
incredibly slow and buggy that I was not even able to take screenshots. Someone
smarter than me could likely get it to work with a little tinkering.

![Emacs](https://img.cleberg.net/blog/20240711-emacs-on-ipad/emacs.png)

### MELPA

You also have to remember to hook up MELPA yourself in the `.emacs` file to be
able to search through their 5700+ packages instead of just ELPA packages. If
you don't, you will only have access to ELPA packages like the ones below.

![package-install](https://img.cleberg.net/blog/20240711-emacs-on-ipad/melpa.png)

Once you have MELPA, you can install packages like the `dashboard` package shown
below.

![emacs-dashboard](https://img.cleberg.net/blog/20240711-emacs-on-ipad/dashboard.png)

### Speed

While Emacs will run on my iPad, it's not perfect. The largest issue on my
iPad is speed - loading Emacs takes 6-7 seconds and installing the `magit`
package took 129 seconds.

I haven't played around enough to optimize loading times and poke around to see
why the network requests take so long, but it's a big enough issue that I
wouldn't see casual Emacs users dealing with the lag.
