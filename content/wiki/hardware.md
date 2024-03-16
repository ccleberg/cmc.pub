+++
title="Hardware"
updated = 2024-03-16T15:42:58+00:00
draft = false
+++

## Desktop

### macOS

Probably should have added more RAM but Macbooks are stupid expensive.

| Category | Details                                               |
|----------|-------------------------------------------------------|
| Model    | [Macbook Pro 16"](https://www.apple.com/macbook-pro/) |
| CPU      | Apple M2 Pro                                          |
| RAM      | 16GB                                                  |
| Storage  | 512GB SSD                                             |

### Linux

A beauty.

| Category | Details                                                                                                                                                |
|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Model    | [Lenovo ThinkPad E15 Gen 4, model 21ED0048US](https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpade/thinkpad--e15-gen-4-(15-inch-amd)/len101t0023) |
| CPU      | AMD Ryzen 5 5625U with Radeon Graphics                                                                                                                 |
| RAM      | 16 GB                                                                                                                                                  |
| Storage  | 256 GB SSD                                                                                                                                             |

## Mobile

Previously used a Pixel 6 & Pixel 7 with GrapheneOS.

| Category | Details                                                   |
|----------|-----------------------------------------------------------|
| Model    | [iPhone 15 Pro Max](https://www.apple.com/iphone-15-pro/) |
| CPU      | A17 Pro                                                   |
| RAM      | 8GB                                                       |
| Storage  | 256GB                                                     |

## Homelab

I run a small homelab with a mix of consumer (compute/storage) and enterprise
(network) hardware. I try to keep the lab energy efficient and quiet as my top
priorities.

### IoT

A collection of mainly smart lights, sensors, and smart appliances. My first preference is to disable all networking for new smart devices or simply not connect internet in the first place (e.g. I never enable internet on my smart TVs). If the smart device requires LAN access, I will connect the device to my guest-restricted IoT network. As a last resort, I will set-up the internet but monitor the DNS lookups via NextDNS and forcibly block any domains I do not want the device to be using. If the device is egregious or shady, I'll just sell it and either replace it or live without it.

- Other Appliances (washer, dryer, humidifier, fans, etc.)
- [Roomba i7+](https://about.irobot.com/sitecore/content/north-america/irobot-us/home/roomba/i7-series)
- [Philips Hue A19 Bulbs](https://www.philips-hue.com/en-us/p/hue-white-and-color-ambiance-a19---e26-smart-bulb---60-w--3-pack-/046677562786) x 15
- [Philips Hue Play Light Bars](https://www.philips-hue.com/en-us/p/hue-bundle-play-blk-ext/33001)
- [Philips Hue Smart Bridge](https://www.philips-hue.com/en-us/p/hue-bridge/046677458478) + play light bars and a ton of bulbs
- [UP Chime](https://store.ui.com/us/en/collections/unifi-camera-security-special-chime)
- [UP-Sense](https://store.ui.com/us/en/collections/unifi-camera-security-special-sensor) x 2
- [USP-Plug](https://store.ui.com/us/en/products/unifi-smart-power)
- [UVC G4 Instant](https://store.ui.com/us/en/collections/unifi-camera-security-compact-wifi-connected) x 3
- [UVC G4 Doorbell Pro](https://store.ui.com/us/en/collections/unifi-camera-security-special-wifi-doorbell)

### Network

A rack-mounted Dream Machine Pro, connected downstream to an access point, mesh
extender, and a couple ethernet switches.

- [UDM-Pro](https://store.ui.com/us/en/collections/unifi-dream-machine/products/udm-pro)
- [USW-24-PoE](https://store.ui.com/us/en/collections/unifi-switching-standard-power-over-ethernet/products/usw-24-poe)
- [USW-Lite-8-PoE](https://store.ui.com/us/en/collections/unifi-switching-utility-poe/products/usw-lite-8-poe)
- [U6-Pro](https://store.ui.com/us/en/collections/unifi-wifi-flagship-high-capacity/products/u6-pro)
- [U6-Extender](https://store.ui.com/us/en/collections/unifi-wifi-inwall-outlet-mesh)
- [USW 24-Port Patch Panel](https://store.ui.com/us/en/collections/unifi-accessory-tech-installations-rackmount/products/uacc-rack-panel-patch-blank-24)

### Servers

#### Rack-Mount Server

I wasn't happy with using low-powered PCs as servers and I knew I did not want
the ear-shattering enterprise rack-mounted servers, so I built my own.

| Category           | Details                                |
| ------------------ | -------------------------------------- |
| Case               | Rosewill RSV-R4100U 4U                 |
| Motherboard        | NZXT B550                              |
| CPU                | AMD Ryzen 7 5700G with Radeon Graphics |
| RAM                | 64GB RAM (2x32GB)                      |
| Storage (On-board) | Western Digital 500GB M.2 NVME SSD     |
| Storage (HDD Bay)  | 48TB HDD                               |
| PSU                | Corsair RM850 PSU                      |

#### Other

These ran as my main servers before I built the rack-mounted server above. I
have shut these down indefinitely for now as I have no use for them.

- Dell OptiPlex
- Raspberry Pi 4
