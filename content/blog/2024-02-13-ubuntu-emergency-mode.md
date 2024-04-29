+++
date = 2024-02-13
title = "Stuck in Ubuntu's Emergency Mode? Try Fixing the Fstab File"
description = ""
draft = false
+++

# The Problem

I recently [migrated my hard drives to a ZFS pool](../zfs/) and found myself
stuck in Ubuntu's emergency mode after the first reboot I performed after
creating the ZFS pool.

My server was stuck in the boot process and showed the following error on the
screen:

``` txt
You are in emergency mode.
After logging in, type "journalctl -xb" to view system logs,
"systemctl reboot" to reboot, "systemctl default"
or ^D to try again to boot into default mode".
```

After rebooting the server and watching the logs scroll on a monitor, I noticed
the root cause was related to a very long search for certain drives. I kept
seeing errors like this:

``` txt
[ TIME ] Timed out waiting of device dev-disk-by/[disk-uuid]
```

I realized that I had not removed the `/etc/fstab` references that asked Ubuntu
to mount two disks on boot, but I had recently changed those disks to be part of
my ZFS pool instead. Therefore, Ubuntu was trying to identify and mount a disk
that was not available.

Now that we have an idea of the issue, let's move to solution.

# The Solution

In order to fix the issue, I waited until I was allowed to type the root user's
password, and then I executed the following command:

```sh
nano /etc/fstab
```

Within the `fstab` file, I needed to comment/remove the following lines at the
bottom of the file. You can comment-out a line by prepending a `#` symbol at the
beginning of the line. You can also delete the line entirely.

``` conf
# What it looked like when running into the issue:
UUID=B64E53824E5339F7 /mnt/white-01 ntfs-3g uid=1000,gid=1000 0 0
UUID=E69867E59867B32B /mnt/white-02 ntfs-3g uid=1000,gid=1000 0 0

# What I changed it to, in order to fix the issue:
# UUID=B64E53824E5339F7 /mnt/white-01 ntfs-3g uid=1000,gid=1000 0 0
# UUID=E69867E59867B32B /mnt/white-02 ntfs-3g uid=1000,gid=1000 0 0
```

Once removing the lines above from the `/etc/fstab` file, save and exit the file
by hitting the `Ctrl` + `x` key combo.

You can now hit `Ctrl` + `D` to continue, or reboot:

```sh
systemctl reboot
```

Once rebooted, I was able to watch the machine boot properly and launch to the
TTY login screen without errors!
