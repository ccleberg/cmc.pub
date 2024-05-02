+++
date = 2021-10-09
title = "Apache Redirect HTML Files to a Directory"
description = ""
draft = false
+++

# The Problem

After recently switching static site generators (SSG), my blog URLs changed with
no option to preserve the classic `.html` extension at the end of my blog post
URLs.

I really disliked using my old SSG ([Jekyll](https://jekyllrb.com)) and prefer
my new tool ([Zola](https://www.getzola.org)) much more, so I was determined to
figure out a way to get the proper redirect set up so that people who find my
posts online aren't constantly met by 404 errors.

# The Solution

To solve this problem, I really needed to solve two pieces:

1. Redirect all blog post URL requests from `/blog/some-post.html` to
   `/blog/some-post/`.
2. Ensure that no other `.html` files are redirected, such as `index.html`.

After _a lot_ of tweaking and testing, I believe I have finally found the
solution. The solution is shown below.

```conf
RewriteEngine On
RewriteCond %{REQUEST_URI} !\index.html$ [NC]
RewriteRule ^(.*).html$ https://example.com/$1 [R=301,L]
```

This piece of code in the Apache `.conf` or `.htaccess` file will do the
following:

1. Turn on the RewriteEngine so that we can modify URLs.
2. Ignore any `index.html` files from the rule we are about to specify.
3. Find any `.html` files within the website directory and redirect it to
   exclude the file extension.
4. The final piece is adding the trailing slash (`/`) at the end of the URL -
   you'll notice that I don't have an Apache rule for that since Apache handles
   that automatically.
