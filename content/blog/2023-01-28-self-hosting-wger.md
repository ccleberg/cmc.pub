+++
date = 2023-01-28
title = "Self-Hosting Wger Workout Manager"
description = ""
draft = false
+++

# Wger: The Self-Hosted Workout Manager

[Wger Workout Manager](https://wger.de) is a fitness tracking tool for those who
enjoy self-hosting their data. You can also register an account on their main
website if you'd prefer to try without self-hosting.

## Features

I didn't see a full listing of features anywhere, so I compiled this list of my
own after installing wger:

1.  Dashboard

    -   Dashboard view of Workout Schedule, Nutrition Plan, Weight Graph, & last
        5 Weight Logs

2.  Training

    -   Workout Log
    -   Workout Schedule
    -   Calendar (shows weight logs and Bad/Neutral/Good days)
    -   Gallery (shows images you upload)
    -   Workout templates
    -   Public templates
    -   Exercises

3.  Nutrition

    -   Nutrition plans
    -   BMI calculator
    -   Daily calories calculator
    -   Ingredient overview

4.  Body Weight

    -   Weight overview

## Documentation

In order to self-host wger, I opted to use the Docker version of the
application. You can read the README within the
[wger-project/docker](https://github.com/wger-project/docker) project on GitHub
for information and installation instructions.

## Installation

To start the installation, I created a folder for wger and started creating the
three necessary files:

```sh
mkdir ~/wger && mkdir ~/wger/config
touch ~/wger/docker-compose.yml && \
touch ~/wger/config/prod.env && \
touch ~/wger/config/nginx.conf
```

Once you have the folders and files created, you will need to copy the contents
of the `docker-compose.yml`, `prod.env`, and `nginx.conf` from the GitHub link
above.

A few notes to explain the changes I made to the default files:

-   I updated the `ALLOW_REGISTRAION` variable in `prod.env` to `False` after I
    created an account via my LAN connection, **before** I connected this app to
    a publicly-available domain.
-   I uncommented and updated `CSRF_TRUSTED_ORIGINS` to be equal to the public
    version of this app: `https://wger.example.com`.
-   I updated the port within `docker-compose.yml`, within the `nginx` block.
    The port I updated this to will be reflected in my nginx configuration file
    on the server (NOT the wger nginx.conf file).

## Deploy

Once all files are created and modified to your needs, simply start the
container.

```sh
docker-compose up -d
```

You can now visit the website on your LAN by going to `localhost:YOUR_PORT` or
by the server's IP, if you're not on the same machine that is running the
container.

If you wish to connect this app to a public domain name, you'll need to point an
`A` DNS record from the domain to your server's public IP. You'll then need to
create a configuration file for whichever web server or reverse proxy you're
using.

Wger's README suggests the following reverse proxy configuration for Nginx:

```conf
upstream wger {
    # This port should match the port in the `nginx` block of docker-compose.yml
    # If the container is running on this same machine, replace this with
    # server 127.0.0.1:8080
    server 123.456.789.0:8080;
}

server {
    listen 80;
    listen [::]:443 ssl;
    listen 443 ssl;

    location / {
        proxy_pass http://wger;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
    }

    server_name my.domain.example.com;

    ssl_certificate /path/to/https/certificate.crt;
    ssl_certificate_key /path/to/https/certificate.key;
}
```

# Thoughts on Wger

I'm still playing around with the app itself, but it seems to be a solid
all-around workout manager, weight log, and food log.

I like that the weight log graph is fluid and updates quickly. You can also
import or export data in CSV format if you'd like to move your data elsewhere.

The workout manager is slightly odd, as it requires you to enter sets and reps
for each exercise when you enter it into the plan. Then, when you add a log
entry for performing a workout, you then add what you actually performed, in
terms of reps and weight.

I haven't tried the food log yet and I likely will not, at least for a while. I
have no need for a food log or calorie tracker at the moment.
