+++
date = 2022-06-01
title = "Ditching Cloudflare for Njalla"
description = ""
draft = false
+++

# Registrar

After spending a year or so using Cloudflare for DNS only - no proxying or
applications - I spent the last few months using Cloudflare Tunnels and
Cloudflare Access to protect my self-hosted websites and applications via their
proxy traffic model.

However, I have never liked using Cloudflare due to their increasingly large
share of control over web traffic, as well as their business model of being a
MITM for all of your traffic.

So, as of today, I have switched over to [Njalla](https://njal.la) as my
registrar and DNS manager. I was able to easily transfer my domains over
rapidly, with only one domain taking more than 15-30 minutes to propagate.

+I do still have two domains sitting at Cloudflare for the moment while I decide
if they're worth the higher rates (one domain is 30€ and the other is 45€).+

> **Update (2022.06.03)**: I ended up transferring my final two domains over to
> Njalla, clearing my Cloudflare account of personal data, and deleting the
> Cloudflare account entirely. _I actually feel relieved to have moved on to a
> provider I trust._

# DNS

As noted above, I'm using Njalla exclusively for DNS configurations on my
domains.

However, the transfer process was not ideal. As soon as the domains transferred
over, I switched the nameservers from Cloudflare to Njalla and lost most of the
associated DNS records. So, the majority of the time spent during the migration
was simply re-typing all the DNS records back in one-by-one.

This would be much simpler if I were able to edit the plain-text format of the
DNS configuration. I was able to do that at a past registrar (perhaps it was
[Gandi.net](https://gandi.net/)?) and it made life a lot easier.

## Dynamic DNS Updates

I have built an easy Python script to run (or set-up in `cron` to run
automatically) that will check my server's IPv4 and IPv6, compare it to Njalla,
and update the DNS records if they don't match. You can see the full script and
process in my other post: [Updating Dynamic DNS with Njalla
API](../njalla-dns-api/).

I haven't used this other method, but I do know that you can create `Dynamic`
DNS records with Njalla that [work for updating dynamic
subdomains](https://njal.la/docs/ddns/).

## Njalla's DNS Tool

One neat upside to Njalla is that they have a [DNS lookup
tool](https://check.njal.la/dns/) that provides a lot of great information for
those of you (AKA: me) who hate using the `dig` command.

This was very useful for monitoring a couple of my transferred domains to see
when the changes in nameservers, records, and DNSSEC went into effect.

# Tunnel

Cloudflare Tunnel is a service that acts as a reverse-proxy (hosted on
Cloudflare's servers) and allowed me to mask the private IP address of the
server hosting my various websites and apps.

However, as I was moving away from Cloudflare, I was not able to find a suitable
replacement that was both inexpensive and simple. So, I simply went back to
hosting [my own reverse proxy with
Nginx](file:///blog/set-up-nginx-reverse-proxy/). With the recent additions of
Unifi hardware in my server/network rack, I am much more protected against spam
and malicious attacks at the network edge than I was before I switched to
Cloudflare.

# Access

Cloudflare Access, another app I used in combination with Cloudflare Tunnel,
provided an authentication screen that required you to enter valid credentials
before Cloudflare would forward you to the actual website or app (if the
website/app has their own authentication, you'd then have to authenticate a
second time).

I did not replace this service with anything since I only host a handful of
non-sensitive apps that don't require duplicate authentication.
