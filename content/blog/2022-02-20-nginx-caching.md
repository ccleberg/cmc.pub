+++
date = 2022-02-20
title = "Caching Static Content with Nginx"
description = ""
draft = false
+++

# Update Your Nginx Config to Cache Static Files

If you run a website on Nginx that serves static content (i.e., content that is
not dynamic and changing with interactions from the user), you would likely
benefit from caching that content on the client-side. If you're used to Apache
and looking for the Nginx equivalent, this post should help.

Luckily, setting up the cache is as easy as identifying the file types you want
to cache and determining the expiration length. To include more file types,
simply use the bar separator (`|`) and type the new file extension you want to
include.

```config
server {
    ...

    location ~** .(css|js|jpg|jpeg|gif|png|ico)$ {
        expires 30d;
    }

    ...
}
```

I have seen some people who prefer to set `expires` as `365d` or even `max`, but
that is only for stable, infrequently changing websites. As my site often
changes (i.e., I'm never content with my website), I need to know that my
readers are seeing the new content without waiting too long.

So, I went ahead and set the expiration date at `30d`, which is short enough to
refresh for readers but long enough that clients/browsers won't be re-requesting
the static files too often, hopefully resulting in faster loading times, as
images should be the only thing slowing down my site.

# Testing Results

To test my changes to the Nginx configuration, I used the [HTTP Header
Live](https://addons.mozilla.org/en-US/firefox/addon/http-header-live/)
extension on my Gecko browser and used the sidebar to inspect the headers of a
recent image from my blog.

In the image below, you can see that the `Cache-Control` header is now present
and set to 2592000, which is 30 days represented in seconds (30 days \_ 24
hours/day \_ 60 minutes/hour \*\* 60 seconds/minute = 2,592,000 seconds).

The `Expires` field is now showing 22 March 2022, which is 30 days from the day
of this post, 20 February 2022.

# Caveats

Remember that this caching system is **client-side**, which means that content
is only cached for as long as a client allows it. For example, my browser purges
all caches, data, etc. upon exit, so this caching policy will only work as long
as my browser remains open and running.

If you need to test updates to your site, you'll need to clear the cache to see
updates for any file extension you configured. This can often be done with the
`Shift + F5` or `Ctrl + F5` key combinations in most browsers.
