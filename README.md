# cleberg.net

[cleberg.net](https://cleberg.net) is my personal webpage.

## Overview

This website & blog uses Markdown and [Zola](https://www.getzola.org/).

## Building

Local testing:

```sh
zola serve
```

Building:

```sh
zola build
```

If you want to build locally and push remotely, you can include `zola build`
in your CI\CD pipeline, or simply use `scp` after building.

```sh
scp -r public/* user@remote_host:/var/www/your_website/
```
