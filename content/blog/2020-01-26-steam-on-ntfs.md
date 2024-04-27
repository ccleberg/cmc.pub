+++
date = 2020-01-26
title = "Linux Gaming Tweak: Steam on NTFS Drives"
description = ""
draft = false
+++

# Auto-Mount Steam Drives

![Steam
Screenshot](https://img.cleberg.net/blog/20200125-the-best-linux-software/steam.png)

If you want to see how to install Steam on Linux, see my other post:
[Linux Software](../linux-software/).

Are you having trouble launching games, even though they\'ve installed
correctly? This may happen if you\'re storing your games on an
NTFS-formatted drive. This shouldn\'t be an issue if you\'re storing
your games on the same drive that Steam is on, but some gamers prefer to
put Steam on their main drive and game files on another SSD or HDD.

To fix this problem, you\'ll need to try a few things. First, you\'ll
need to install the `ntfs-3g` package, which is meant for
better interoperability with Linux.

```sh
sudo apt install ntfs-3g
```

Next, you should set up the `/etc/fstab` file to
automatically mount your drives on boot. To automatically mount your
drives when the computer boots up, you\'ll have to create the folders
you want to mount your drive to first. I store mine in the
`/mnt` folder using names that I\'ll recognize, but you can
create your folders wherever you want.

```sh
mkdir /path/to/folder
```

For example:

```sh
mkdir /mnt/steam_library
```

To automatically mount drives upon system boot, you will need to collect
a few items. The UUID is the identification number connected to
whichever drive you\'re using to store Steam games.

Drives are usually labeled similar to `/dev/nvme0n1p1` or
`/dev/sda1`, so you\'ll need to find the line in the output
of the command below that correlates to your drive and copy the UUID
over to the `/etc/fstab` file.

```sh
sudo blkid | grep UUID=
```

Next, you\'ll need your `uid` and `gid`. To find
these, run the following command:

```sh
id -u && id -g
```

Now that you have collected the necessary information, open the
`/etc/fstab` file:

```sh
sudo nano /etc/fstab
```

Each drive you want to mount on boot should have its own line in the
`/etc/fstab` file that looks similar to this:

``` config
UUID=B64E53824E5339F7 /mnt/steam_library ntfs-3g uid=1000,gid=1000 0 0
```

Now all you need to do is unmount your drive and re-mount it. You can
unmount the drive by doing this (be sure to use the correct drive name
here):

```sh
sudo umount /dev/sdxX
```

You can re-mount all your drives by executing the following:

```sh
sudo mount -a
```

If you don\'t know what your drive name is, or you\'re nervous about
unmounting and re-mounting, simply reboot your computer, and it will be
done for you automatically.
