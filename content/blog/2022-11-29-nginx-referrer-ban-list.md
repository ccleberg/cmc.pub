+++
date = 2022-11-29
title = "Creating a Referrer Ban List in Nginx"
description = ""
draft = false
+++

# Creating the Ban List

In order to ban list referral domains or websites with Nginx, you need to create
a ban list file. The file below will accept regexes for different domains or
websites you wish to block.

First, create the file in your nginx directory:

```sh
doas nano /etc/nginx/banlist.conf
```

Next, paste the following contents in and fill out the regexes with whichever
domains you're blocking.

```conf
# /etc/nginx/banlist.conf

map $http_referer $bad_referer {
    hostnames;

    default                           0;

    # Put regexes for undesired referrers here
    "~news.ycombinator.com"           1;
}
```

# Configuring Nginx

In order for the ban list to work, Nginx needs to know it exists and how to
handle it. For this, edit the `nginx.conf` file.

```sh
doas nano /etc/nginx/nginx.conf
```

Within this file, find the `http` block and add your ban list file location to
the end of the block.

```conf
# /etc/nginx/nginx.conf

http {
  ...

  # Include ban list
  include /etc/nginx/banlist.conf;
}
```

# Enabling the Ban List

Finally, we need to take action when a bad referral site is found. To do so,
edit the configuration file for your website. For example, I have all website
configuration files in the `http.d` directory. You may have them in the
`sites-available` directory on some distributions.

```sh
doas nano /etc/nginx/http.d/example.com.conf
```

Within each website's configuration file, edit the `server` blocks that are
listening to ports 80 and 443 and create a check for the `$bad_referrer`
variable we created in the ban list file.

If a matching site is found, you can return any [HTTP Status
Code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) you want. Code
403 (Forbidden) is logical in this case since you are preventing a client
connection due to a banned domain.

```conf
server {
  ...

  # If a referral site is banned, return an error
  if ($bad_referer) {
    return 403;
  }

  ...
}
```

# Restart Nginx

Lastly, restart Nginx to enable all changes made.

```sh
doas rc-service nginx restart
```

# Testing Results

In order to test the results, let's curl the contents of our site. To start,
I'll curl the site normally:

```sh
curl https://cleberg.net
```

The HTML contents of the page come back successfully:

```html
<!doctype html>...</html>
```

Next, let's include a banned referrer:

```sh
curl --referer https://news.ycombinator.com https://cleberg.net
```

This time, I'm met with a 403 Forbidden response page. That means we are
successful and any clients being referred from a banned domain will be met with
this same response code.

```html
<html>
	<head>
		<title>403 Forbidden</title>
	</head>
	<body>
		<center><h1>403 Forbidden</h1></center>
		<hr />
		<center>nginx</center>
	</body>
</html>
```
