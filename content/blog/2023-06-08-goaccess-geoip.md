+++
date = 2023-06-08
title = "Inspecting Nginx Logs with GoAccess and MaxMind GeoIP Data"
description = ""
draft = false
+++

# Overview

[GoAccess](https://goaccess.io/) is an open source real-time web log
analyzer and interactive viewer that runs in a terminal in \*nix systems
or through your browser.

# Installation

To start, you\'ll need to install GoAccess for your OS. Here\'s an
example for Debian-based distros:

```sh
sudo apt install goaccess
```

Next, find any number of the MaxMind GeoIP database files on GitHub or
another file hosting website. We\'re going to use P3TERX\'s version in
this example:

```sh
wget https://github.com/P3TERX/GeoLite.mmdb/raw/download/GeoLite2-City.mmdb
```

Be sure to save this file in an easy to remember location!

# Usage

In order to utilize the full capabilities of GoAccess and MMDB, start
with the command template below and customize as necessary. This will
export an HTML view of the GoAccess dashboard, showing all relevant
information related to that site\'s access log. You can also omit the
`-o output.html` parameter if you prefer to view the data
within the CLI instead of creating an HTML file.

With the addition of the GeoIP Database parameter, section
`16 - Geo Location` will be added with the various countries
that are associated with the collected IP addresses.

```sh
zcat /var/log/nginx/example.access.log.*.gz | goaccess     \
--geoip-database=/home/user/GeoLite2-City.mmdb             \
--date-format=%d/%b/%Y                                     \
--time-format=%H:%M:%S                                     \
--log-format=COMBINED                                      \
-o output.html                                             \
/var/log/nginx/example.access.log -
```

## Example Output

See below for an example of the HTML output:

![GoAccess
HTML](https://img.cleberg.net/blog/20230608-goaccess/goaccess-dashboard.png)

You can also see the GeoIP card created by the integration of the
MaxMind database information.

![GoAccess
GeoIP](https://img.cleberg.net/blog/20230608-goaccess/goaccess-geoip.png)

That\'s all there is to it! Informational data is provided in an
organized fashion with minimal effort.
