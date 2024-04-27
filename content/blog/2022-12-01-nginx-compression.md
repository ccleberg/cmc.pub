+++
date = 2022-12-01
title = "Enable GZIP Compression in Nginx"
description = ""
draft = false
+++

# Text Compression

Text compression allows a web server to serve text-based resources
faster than uncompressed data. This can speed up things like First
Contentful Paint, Tie to Interactive, and Speed Index.

# Enable Nginx Compression with gzip

In order to enable text compression on Nginx, we need to enable it
within the configuration file:

```sh
nano /etc/nginx/nginx.conf
```

Within the `http` block, find the section that shows
something like the block below. This is the default gzip configuration I
found in my `nginx.conf` file on Alpine Linux 3.17. Yours may
look slightly different, just make sure that you\'re not creating any
duplicate gzip options.

``` conf
# Enable gzipping of responses.
#gzip on;

# Set the Vary HTTP header as defined in the RFC 2616. Default is 'off'.
gzip_vary on;
```

Remove the default gzip lines and replace them with the following:

``` conf
# Enable gzipping of responses.
gzip on;
gzip_vary on;
gzip_min_length 10240;
gzip_proxied expired no-cache no-store private auth;
gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
gzip_disable "MSIE [1-6]";
```

# Explanations of ngx~httpgzipmodule~ Options

Each of the lines above enables a different aspect of the gzip response
for Nginx. Here are the full explanations:

-   `gzip` -- Enables or disables gzipping of responses.
-   `gzip_vary` -- Enables or disables inserting the \"Vary:
    Accept-Encoding\" response header field if the directives gzip,
    gzip~static~, or gunzip are active.
-   `gzip_min_length` -- Sets the minimum length of a
    response that will be gzipped. The length is determined only from
    the \"Content-Length\" response header field.
-   `gzip_proxied` -- Enables or disables gzipping of
    responses for proxied requests depending on the request and
    response. The fact that the request is proxied is determined by the
    presence of the \"Via\" request header field.
-   `gzip_types` -- Enables gzipping of responses for the
    specified MIME types in addition to \"text/html\". The special value
    "\*" matches any MIME type (0.8.29). Responses with the
    \"text/html\" type are always compressed.
-   `gzip_disable` -- Disables gzipping of responses for
    requests with \"User-Agent\" header fields matching any of the
    specified regular expressions.
    -   The special mask \"msie6\" (0.7.12) corresponds to the regular
        expression \"MSIE \[4-6\].\", but works faster. Starting from
        version 0.8.11, \"MSIE 6.0; ... SV1\" is excluded from this
        mask.

More information on these directives and their options can be found on
the [Module
ngx~httpgzipmodule~](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)
page in Nginx\'s documentation.
