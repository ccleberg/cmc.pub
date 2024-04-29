+++
date = 2023-07-12
title = "Enable LAN Access in Mullvad Wireguard Configuration Files"
description = ""
draft = false
+++

# Download Configuration Files from Mullvad

To begin, you'll need [Wireguard configuration files from
Mullvad](https://mullvad.net/account/wireguard-config). You can choose any of
the options as you download them. For example, I enabled the kill switch,
selected all countries, and selected a few content filters.

Once downloaded, unzip the files and move them to the Wireguard folder on your
system.

```sh
cd ~/Downloads
unzip mullvad_wireguard_linux_all_all.zip
doas mv *.conf /etc/wireguard/
```

## Configuration File Layout

The default configuration files will look something like this:

``` conf
[Interface]
# Device: <redacted>
PrivateKey = <redacted>
Address = <redacted>
DNS = <redacted>
PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT

[Peer]
PublicKey = <redacted>
AllowedIPs = <redacted>
Endpoint = <redacted>
```

> Note: If you didn't select the kill switch option, you won't see the
> `PostUp` and `PreDown` lines. In this case, you'll need to modify the script
> below to simply append those lines to the `[Interface]` block.

# Editing the Configuration Files

Once you have the files, you'll need to edit them and replace the `PostUp` and
`PreDown` lines to enable LAN access.

I recommend that you do this process as root, since you'll need to be able to
access files in `/etc/wireguard`, which are generally owned by root. You can
also try using `sudo` or `doas`, but I didn't test that scenario so you may
need to adjust, as necessary.

```sh
su
```

Create the Python file that we'll be using to update the Wireguard
configuration files.

```sh
nano replace.py
```

Within the Python file, copy and paste the logic below. This script will open a
directory, loop through every configuration file within the directory, and
replace the `PostUp` and `PreDown` lines with the new LAN-enabled iptables
commands.

> Note: If your LAN is on a subnet other than `192.168.1.0/24`, you'll need to
> update the Python script below appropriately.

``` python
import os
import fileinput

print("--- starting ---")

dir = "/etc/wireguard/"

for file in os.listdir(dir):
    print(os.path.join(dir, file))
    for line in fileinput.input(os.path.join(dir, file), inplace=True):
        if "PostUp" in line:
            print("PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL ! -d 192.168.1.0/24 -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT")
        elif "PreDown" in line:
            print("PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL ! -d 192.168.1.0/24 -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT")
        else:
            print(line, end="")

print("--- done ---")
```

Once you're done, save and close the file. You can now run the Python script
and watch as each file is updated.

```sh
python3 replace.py
```

To confirm it worked, you can `cat` one of the configuration files to inspect
the new logic and connect to one to test it out.

```sh
cat /etc/wireguard/us-chi-wg-001.conf
```

The configuration files should now look like this:

``` conf
[Interface]
# Device: <redacted>
PrivateKey = <redacted>
Address = <redacted>
DNS = <redacted>
PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL ! -d 192.168.1.0/24 -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL ! -d 192.168.1.0/24 -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT

[Peer]
PublicKey = <redacted>
AllowedIPs = <redacted>
Endpoint = <redacted>
```

If you connect to a Wireguard interface, such as `us-chi-wg-001`, you can test
your SSH functionality and see that it works even while on the VPN.

```sh
wg-quick up us-chi-wg-001
ssh user@lan-host
```

To confirm your VPN connection, you can curl Mullvad's connection API:

```sh
curl https://am.i.mullvad.net/connected
# You are connected to Mullvad (server us-chi-wg-001). Your IP address is <redacted>
```
