+++
date = 2022-09-21
title = "Installing Graphene OS on the Pixel 6 Pro"
description = ""
draft = false
+++

# Introduction

After using iOS for a couple of years, I finally took the plunge and purchased a
Pixel 6 Pro in order to test and use [GrapheneOS] (<https://grapheneos.org>).

The installation process was rather quick once you have the tools and files you
need. Overall, it can be done in just a few minutes.

# Gathering Tools & Files

## Android Tools

First, in order to interact with the device, we will need the [Android platform
tools](https://developer.android.com/studio/releases/platform-tools.html). Find
the Linux download and save the ZIP folder to your preferred location.

Once we've downloaded the files, we will need to unzip them, enter the
directory, and move the necessary executables to a central location, such as
`/usr/bin/`. For this installation, we only need the `fastboot` and `adb`
executables.

```sh
cd ~/Downloads
```

```sh
unzip platform-tools_r33.0.3-linux.zip
cd platform-tools
sudo mv fastboot /usr/bin/
sudo mv adb /usr/bin
```

## GrapheneOS Files

Next, we need the [GrapheneOS files](https://grapheneos.org/releases) for our
device and model. For example, the Pixel 6 Pro is codenamed `raven` on the
release page.

Once we have the links, let's download them to our working directory:

```sh
curl -O https://releases.grapheneos.org/factory.pub
curl -0 https://releases.grapheneos.org/raven-factory-2022091400.zip
curl -0 https://releases.grapheneos.org/raven-factory-2022091400.zip.sig
```

1.  Validate Integrity

    In order to validate the integrity of the downloaded files, we will need the
    `signify` package and Graphene's `factory.pub` file.

    ```sh
    sudo dnf install signify
    ```

    ```sh
    curl -O https://releases.grapheneos.org/factory.pub
    ```

    Then we can validate the files and ensure that no data was corrupted or
    modified before it was saved to our device.

    ```sh
    signify -Cqp factory.pub -x raven-factory-2022091400.zip.sig && echo verified
    ```

2.  Unzip Files

    Once the files are verified, we can unzip the Graphene image and enter the
    directory:

    ```sh
    unzip raven-factory-2022091400.zip && cd raven-factory-2022091400
    ```

# Installation Process

## Enable Developer Debugging & OEM Unlock

Before we can actually flash anything to the phone, we will need to enable OEM
Unlocking, as well as either USB Debugging or Wireless Debugging, depending on
which method we will be using.

To start, enable developer mode by going to `Settings` > `About` and tapping
`Build Number` seven (7) times. You may need to enter your PIN to enable this
mode.

Once developer mode is enabled, go to `Settings` > `System` > `Devloper
Options` and enable OEM Unlocking, as well as USB or Wireless Debugging. In my
case, I chose USB Debugging and performed all actions via USB cable.

Once these options are enabled, plug the phone into the computer and execute the
following command:

```sh
adb devices
```

If an unauthorized error occurs, make sure the USB mode on the phone is changed
from charging to something like "File Transfer" or "PTP." You can find the
USB mode in the notification tray.

## Reboot Device

Once we have found the device via `adb`, we can either boot into the bootloader
interface by holding the volume down button while the phone reboots or by
executing the following command:

```sh
adb reboot bootloader
```

## Unlock the Bootloader

The phone will reboot and load the bootloader screen upon startup. At this
point, we are ready to start the actual flashing of GrapheneOS onto the device.

**NOTE**: In my situation, I needed to use `sudo` with every `fastboot` command,
but not with `adb` commands. I am not sure if this is standard or a Fedora
quirk, but I'm documenting my commands verbatim in this post.

First, we start by unlocking the bootloader so that we can load other ROMs:

```sh
sudo fastboot flashing unlock
```

## Flashing Factory Images

Once the phone is unlocked, we can flash it with the `flash-all.sh` script found
inside the `raven-factory-2022091400` folder we entered earlier:

```sh
sudo ./flash-all.sh
```

This process should take a few minutes and will print informational messages as
things progress. Avoid doing anything on the phone while this process is
operating.

## Lock the Bootloader

If everything was successful, the phone should reboot a few times and finally
land back on the bootloader screen. At this point, we can re-lock the bootloader
to enable full verified boot and protect the device from unwanted flashing or
erasure of data.

```sh
sudo fastboot flashing lock
```

Once done, the device will be wiped and ready for a fresh set-up!
