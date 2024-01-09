# cleberg.net

## Overview

This website & blog uses Markdown and [Zola](https://www.getzola.org/).

## Configuration

If you want to replicate this project structure, you'll need to customize your
=.emacs= file appropriately, or load a custom =.el= file.

If you're within emacs while changing =.emacs=, you'll need to reload the
configuration with =M-x load-file= and hit enter to reload the current file
(=.emacs=).

See the [[./elisp/publish.el][publish.el]] file for this repository's 
configuration.

* Building

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
