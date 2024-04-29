+++
date = 2022-03-23
title = "Dynamic DNS with Cloudflare API"
description = ""
draft = false
+++

# DDNS: Dynamic DNS

If you're hosting a service from a location with dynamic DNS (where your IP may
change at any time), you must have a solution to update the DNS so that you can
access your service even when the IP of the server changes.

The process below uses the [Cloudflare API](https://api.cloudflare.com/) to
update DNS `A` and `AAAA` records with the server's current IP. If you use
another DNS provider, you will have to find a way to update your DNS (or find a
way to get a static IP).

First, install `jq` since we will use it in the next script:

```sh
sudo apt install jq
```

Next, create a location for your DDNS update scripts and open the first script:

```sh
mkdir ~/ddns
nano ~/ddns/update.sh
```

The following `update.sh` script will take all of your domains and subdomains
and check Cloudflare to see if the current `A` and `AAAA` records match your
server's IP address. If not, it will update the records.

```sh
# file: update.sh
#!/bin/bash

# Update TLDs
domains=(example.com example.net)

for domain in "${domains[@]}"
do
  echo -e "\nUpdating $domain..."
  zone_name=$domain /home/<your-username>/ddns/ddns.sh
done

# Update subdomains for example.com
domain=example.com
subdomains=(photos.example.com)

for subdomain in "${subdomains[@]}"
do
  echo -e "\nUpdating $subdomain..."
  zone_name=$domain  dns_record=$subdomain /home/<your-username>/ddns/ddns.sh
done
```

Next, open up the `ddns.sh` script. Paste the following into the script and
update the `api_token` and `email` variables.

```sh
nano ~/ddns/ddns.sh
```

**Note**: If you want your DNS records to be proxied through Cloudflare, find
and update the following snippet: `"proxied":false}"` to say `true` instead of
`false`.

```sh
# file: ddns.sh
#!/bin/bash
# based on https://gist.github.com/Tras2/cba88201b17d765ec065ccbedfb16d9a
# initial data; they need to be filled by the user
## API token
api_token=<YOUR_API_TOKEN>
## email address associated with the Cloudflare account
email=<YOUR_EMAIL>

# get the basic data
ipv4=$(curl -s -X GET -4 https://ifconfig.co)
ipv6=$(curl -s -X GET -6 https://ifconfig.co)
user_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
               -H "Authorization: Bearer $api_token" \
               -H "Content-Type:application/json" \
          | jq -r '{"result"}[] | .id'
         )

echo "Your IPv4 is: $ipv4"
echo "Your IPv6 is: $ipv6"

# check if the user API is valid and the email is correct
if [ $user_id ]
then
    zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name&status=active" \
                   -H "Content-Type: application/json" \
                   -H "X-Auth-Email: $email" \
                   -H "Authorization: Bearer $api_token" \
              | jq -r '{"result"}[] | .[0] | .id'
             )
    # check if the zone ID is
    if [ $zone_id ]
    then
        # check if there is any IP version 4
        if [ $ipv4 ]
        then
            dns_record_a_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?type=A&name=$dns_record"  \
                                   -H "Content-Type: application/json" \
                                   -H "X-Auth-Email: $email" \
                                   -H "Authorization: Bearer $api_token"
                             )
            # if the IPv6 exist
            dns_record_a_ip=$(echo $dns_record_a_id |  jq -r '{"result"}[] | .[0] | .content')
            echo "The set IPv4 on Cloudflare (A Record) is:    $dns_record_a_ip"
            if [ $dns_record_a_ip != $ipv4 ]
            then
                # change the A record
                curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$(echo $dns_record_a_id | jq -r '{"result"}[] | .[0] | .id')" \
                     -H "Content-Type: application/json" \
                     -H "X-Auth-Email: $email" \
                     -H "Authorization: Bearer $api_token" \
                     --data "{"type":"A","name":"$dns_record","content":"$ipv4","ttl":1,"proxied":false}" \
                | jq -r '.errors'
            else
                echo "The current IPv4 and DNS record IPv4 are the same."
            fi
        else
            echo "Could not get your IPv4. Check if you have it; e.g. on https://ifconfig.co"
        fi

        # check if there is any IP version 6
        if [ $ipv6 ]
        then
            dns_record_aaaa_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?type=AAAA&name=$dns_record"  \
                                      -H "Content-Type: application/json" \
                                      -H "X-Auth-Email: $email" \
                                      -H "Authorization: Bearer $api_token"
                                )
            # if the IPv6 exist
            dns_record_aaaa_ip=$(echo $dns_record_aaaa_id | jq -r '{"result"}[] | .[0] | .content')
            echo "The set IPv6 on Cloudflare (AAAA Record) is: $dns_record_aaaa_ip"
            if [ $dns_record_aaaa_ip != $ipv6 ]
            then
                # change the AAAA record
                curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$(echo $dns_record_aaaa_id | jq -r '{"result"}[] | .[0] | .id')" \
                     -H "Content-Type: application/json" \
                     -H "X-Auth-Email: $email" \
                     -H "Authorization: Bearer $api_token" \
                     --data "{"type":"AAAA","name":"$dns_record","content":"$ipv6","ttl":1,"proxied":false}" \
                | jq -r '.errors'
            else
                echo "The current IPv6 and DNS record IPv6 are the same."
            fi
        else
            echo "Could not get your IPv6. Check if you have it; e.g. on https://ifconfig.co"
        fi
    else
        echo "There is a problem with getting the Zone ID. Check if the Zone Name is correct."
    fi
else
    echo "There is a problem with either the email or the password"
fi
```

Once the script is saved and closed, make the scripts executable:

```sh
chmod +x ~/ddns/ddns.sh
chmod +x ~/ddns/update.sh
```

You can test the script by running it manually:

```sh
./update.sh
```

To make sure the scripts run automatically, add it to the `cron` file so that it
will run on a schedule. To do this, open the cron file:

```sh
crontab -e
```

In the cron file, paste the following at the bottom of the editor:

```sh
*/5 ** ** ** ** bash /home/<your_username>/ddns/update.sh
```
