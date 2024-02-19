+++
title = "Wiki"
description = "An informal wiki of sorts."
+++

An informal wiki of sorts.

## Digital Garden

> At times, wilderness is exactly what readers want: a rich collection
> of resources and links. At times, rigid formality suits readers
> perfectly, providing precisely the information they want, no more and
> no less. Indeed, individual hypertexts and Web sites may contain
> sections that tend toward each extreme.

> Often, however, designers should strive for the comfort, interest, and
> habitability of parks and gardens: places that invite visitors to
> remain, and that are designed to engage and delight them, to invite
> them to linger, to explore, and to reflect.

[Hypertext Garden](https://www.eastgate.com/garden/)

## Git

I want to get rid of all local modifications and go back to the working
tree of the most recent commit:

```sh
git restore .
```

Revert a specified commit:

```sh
git revert commit-id
```

Reset the repository to a specific commit in the git log:

```sh
git reset --mixed commit-id
```

I need to commit and push changes to a remote that has been changed
since my most recent pull:

```sh
git pull --rebase
```

## Hardware

### Laptops

#### macOS

| Category | Details         |
| -------- | --------------- |
| Model    | Macbook Pro 16" |
| CPU      | Apple M2 Pro    |
| RAM      | 16GB            |
| Storage  | 512GB SSD       |

#### Linux

| Category | Details                                     |
| -------- | ------------------------------------------- |
| Model    | Lenovo ThinkPad E15 Gen 4, model 21ED0048US |
| CPU      | AMD Ryzen 5 5625U with Radeon Graphics      |
| RAM      | 16 GB                                       |
| Storage  | 256 GB SSD                                  |

### Servers

| Category           | Details                                |
| ------------------ | -------------------------------------- |
| Case               | Rosewill RSV-R4100U 4U                 |
| Motherboard        | NZXT B550                              |
| CPU                | AMD Ryzen 7 5700G with Radeon Graphics |
| RAM                | 64GB RAM (2x32GB)                      |
| Storage (On-board) | Western Digital 500GB M.2 NVME SSD     |
| Storage (HDD Bay)  | 48TB HDD                               |
| PSU                | Corsair RM850 PSU                      |

### Networking Equipment

- UDM-Pro
- USW-24-PoE
- USW-Lite-8-PoE
- U6-Pro
- U6-Extender
- USP-Plug
- UVC G4 Instant x 3
- UVC G4 Doorbell Pro
- UP Chime
- USW 24-Port Patch Panel
- USW Switch Lite 8 PoE

## Software

### Laptop

Alpine 3.18.2; no DE.

I currently run my Alpine laptop via the default login shell - no
desktop environment. From here, I use a mix of byobu and emacs to split
my screen into tabs and panes. All programs run through the shell and do
not use visual libraries such as X or Wayland.

I have Sway installed and configured, but only launch it when I must.

- brightnessctl
- byobu
- emacs
- [font-dejavu, font-noto, font-noto-cjk, font-noto-cjk-extra]
- glances
- gnupg
- irssi
- lynx
- nano
- neomutt
- newsboat
- ohmyzsh
- [pango, pango-tools]
- pipewire
- syncthing
- wireguard
- zola
- zsh

### Server

Ubuntu 22.04.1; no DE.

See my services page for a list of the publicly-available services
running on this server.

- certbot
- [docker, docker-compose]
- nginx
- zsh
