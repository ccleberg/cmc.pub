+++
date = 2022-02-10
title = "Dynamic DNS with Njalla API"
description = ""
draft = false
+++

# Njalla's API

As noted in my recent post about [switching to Njalla from
Cloudflare](file:///blog/ditching-cloudflare/), I was searching for a way to
replace my very easy-to-use bash script to [update Cloudflare's DNS via their
API](file:///blog/cloudflare-dns-api/).

To reiterate what I said in those posts, this is a common necessity for those of
us who have non-static IP addresses that can change at any moment due to ISP
policy.

In order to keep a home server running smoothly, the server admin needs to have
a process to constantly monitor their public IP address and update their
domain's DNS records if it changes.

This post explains how to use Python to update Njalla's DNS records whenever a
machine's public IP address changes.

## Creating a Token

To use Njalla's API, you will first need to create a token that will be used to
authenticate you every time you call the API. Luckily, this is very easy to do
if you have an account with Njalla.

Simply go the [API Settings](https://njal.la/settings/api/) page and click the
`Add Token` button. Next, enter a name for the token and click `Add`.

Finally, click the `Manage` button next to your newly created token and copy the
`API Token` field.

## Finding the Correct API Request

Once you have a token, you're ready to call the Njalla API for any number of
requests. For a full listing of available requests, see the [Njalla API
Documentation](https://njal.la/api/).

For this demo, we are using the `list-records` and `edit-record` requests.

The `list-records` request requires the following payload to be sent when
calling the API:

```txt
params: {
    domain: string
}
```

The `edit-record` request requires the following payload to be sent when calling
the API:

```txt
params: {
    domain: string
    id: int
    content: string
}
```

# Server Set-Up

To create this script, we will be using Python. By default, I use Python 3 on my
servers, so please note that I did not test this in Python 2, and I do not know
if Python 2 will work for this.

## Creating the Script

First, find a suitable place to create your script. Personally, I just create a
directory called `ddns` in my home directory:

```sh
mkdir ~/ddns
```

Next, create a Python script file:

```sh
nano ~/ddns/ddns.py
```

The following code snippet is quite long, so I won't go into depth on each part.
However, I suggest you read through the entire script before running it; it is
quite simple and contains comments to help explain each code block.

:warning: **Note**: You will need to update the following variables for this to
work:

-   `token`: This is the Njalla API token you created earlier.
-   `user_domain`: This is the top-level domain you want to modify.
-   `include_subdomains`: Set this to `True` if you also want to modify
    subdomains found under the TLD.
-   `subdomains`: If `include_subdomains` = `True`, you can include your list of
    subdomains to be modified here.

```python
#!/usr/bin/python
# -*- coding: utf-8 -*-
# Import Python modules

from requests import get
import requests
import json

# Set global variables

url = 'https://njal.la/api/1/'
token = '<your-api-token>'
user_domain = 'example.com'
include_subdomains = True
subdomains = ['one', 'two']


# Main API call function

def njalla(method, **params):
    headers = {'Authorization': 'Njalla ' + token}
    response = requests.post(url, json={'method': method,
                             'params': params}, headers=headers).json()
    if 'result' not in response:
        raise Exception('API Error', response)
    return response['result']


# Gather all DNS records for a domain

def get_records(domain):
    return njalla('list-records', domain=user_domain)


# Update a DNS record for a domain

def update_record(domain, record_id, record_content):
    return njalla('edit-record', domain=domain, id=record_id,
                  content=record_content)


# Get public IP addresses

ipv4 = get('https://api.ipify.org').text
print('IPv4: {}'.format(ipv4))
ipv6 = get('https://api64.ipify.org').text
print('IPv6: {}'.format(ipv6))

# Call API to get all DNS records

data = get_records(user_domain)

# Loop through records and check if each one is IPv4 (A) or IPv6 (AAAA)
# Update only if DNS is different from server IP

for record in data['records']:
    if record['name'] == '@' or (include_subdomains and record['name'] \
        in subdomains):
        if record['type'] == 'A':
            if record['content'] == ipv4:
                print(record['type'], 'record for', record['name'],
                      'already matches public IPv4 address. Skipping...'
                      )
            else:
                print('IPv4 of', ipv4,
                      'does not match Njalla's value of',
                      record['content'], '. Updating...')
                update_record(user_domain, record['id'], ipv4)
        elif record['type'] == 'AAAA':
            if record['content'] == ipv6:
                print(record['type'], 'record for', record['name'],
                      'already matches public IPv6 address. Skipping...'
                      )
            else:
                print('IPv6 of', ipv6,
                      'does not match Njalla's value of',
                      record['content'], '. Updating...')
                update_record(user_domain, record['id'], ipv6)
```

## Running the Script

Once you've created the script and are ready to test it, run the following
command:

```sh
python3 ~/ddns/ddns.py
```

## Setting the Script to Run Automatically

To make sure the scripts run automatically, add it to the `cron` file so that it
will run on a schedule. To do this, open the `cron` file:

```sh
crontab -e
```

In the cron file, paste the following at the bottom of the editor in order to
check the IP every five minutes:

```sh
*/5 ** ** ** ** python3 /home/<your_username>/ddns/ddns.py
```
