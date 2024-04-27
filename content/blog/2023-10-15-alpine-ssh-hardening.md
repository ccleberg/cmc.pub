+++
date = 2023-10-15
title = "SSH Hardening for Alpine Linux"
description = ""
draft = false
+++

# Overview

This guide follows the standard
[ssh-audit](https://www.ssh-audit.com/hardening_guides.html) hardening
guide, tweaked for Alpine Linux.

# Hardening Guide

These steps must be performed as root. You can try to use
`doas` or `sudo`, but there may be issues.

1.  Re-generate the RSA and ED25519 keys

```sh
rm /etc/ssh/ssh_host_*
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
```

2.  Remove small Diffie-Hellman moduli

```sh
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli
```

3.  Enable the RSA and ED25519 HostKey directives in the
    /etc/ssh/sshd~config~ file

```sh
sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
```

4.  Restrict supported key exchange, cipher, and MAC algorithms

```sh
echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com" > /etc/ssh/sshd_config.d/ssh-audit_hardening.conf
```

5.  Include the /etc/ssh/sshd~config~.d directory

```sh
echo -e "Include /etc/ssh/sshd_config.d/*.conf" > /etc/ssh/sshd_config
```

6.  Restart OpenSSH server

```sh
rc-service sshd restart
```

# Testing SSH

You can test the results with the `ssh-audit` python script.

```sh
pip3 install ssh-audit
ssh-audit localhost
```

If everything succeeded, the results will show as all green. If anything
is yellow, orange, or red, you may need to tweak additional settings.

``` txt
#+caption: ssh audit
```

![ssh-audit](https://img.cleberg.net/blog/20231015-ssh-hardening/ssh-audit.png)
