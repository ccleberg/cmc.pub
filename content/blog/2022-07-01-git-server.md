+++
date = 2022-07-01
title = "Self-Hosting a Personal Git Server"
description = ""
draft = false
+++

# My Approach to Self-Hosting Git

I have often tried to self-host my Git repositories, but have always
fallen short when I tried to find a suitable web interface to show on
the front-end.

After a few years, I have finally found a combination of methods that
allow me to easily self-host my projects, view them on the web, and
access them from anywhere.

Before I dive into the details, I want to state a high-level summary of
my self-hosted Git approach:

-   This method uses the `ssh://` (read & write) and
    `git://` (read-only) protocols for push and pull access.
    -   For the `git://` protocol, I create a
        `git-daemon-export-ok` file in any repository that I
        want to be cloneable by anyone.
    -   The web interface I am using (`cgit`) allows simple
        HTTP cloning by default. I do not disable this setting as I want
        beginners to be able to clone one of my repositories even if
        they don\'t know the proper method.
-   I am not enabling Smart HTTPS for any repositories. Updates to
    repositories must be pushed via SSH.
-   Beyond the actual repository management, I am using
    `cgit` for the front-end web interface.
    -   If you use the `scan-path=<path>` configuration in
        the `cgitrc` configuration file to automatically find
        repositories, you can\'t exclude a repository from
        `cgit` if it\'s stored within the path that
        `cgit` reads. To host private repositories, you\'d
        need to set up another directory that `cgit` can\'t
        read.

# Assumptions

For the purposes of this walkthrough, I am assuming you have a URL
(`git.example.com`) or IP address
(`207.84.26.991`) addressed to the server that you will be
using to host your git repositories.

# Adding a Git User

In order to use the SSH method associated with git, we will need to add
a user named `git`. If you have used the SSH method for other
git hosting sites, you are probably used to the following syntax:

```sh
git clone [user@]server:project.git
```

The syntax above is an `scp`-like syntax for using SSH on the
`git` user on the server to access your repository.

Let\'s delete any remnants of an old `git` user, if any, and
create the new user account:

```sh
sudo deluser --remove-home git
sudo adduser git
```

## Import Your SSH Keys to the Git User

Once the `git` user is created, you will need to copy your
public SSH key on your local development machine to the `git`
user on the server.

If you don\'t have an SSH key yet, create one with this command:

```sh
ssh-keygen
```

Once you create the key pair, the public should be saved to
`~/.ssh/id_rsa.pub`.

If your server still has password-based authentication available, you
can copy it over to your user\'s home directory like this:

```sh
ssh-copy-id git@server
```

Otherwise, copy it over to any user that you can access.

```sh
scp ~/.ssh/id_rsa.pub your_user@your_server:
```

Once on the server, you will need to copy the contents into the
`git` user\'s `authorized_keys` file:

```sh
cat id_rsa.pub > /home/git/.ssh/authorized_keys
```

## (Optional) Disable Password-Based SSH

If you want to lock down your server and ensure that no one can
authenticate in via SSH with a password, you will need to edit your SSH
configuration.

```sh
sudo nano /etc/ssh/sshd_config
```

Within this file, find the following settings and set them to the values
I am showing below:

``` conf
PermitRootLogin no
PasswordAuthentication no
AuthenticationMethods publickey
```

You may have other Authentication Methods required in your personal
set-up, so the key here is just to ensure that
`AuthenticationMethods` does not allow passwords.

### Setting up the Base Directory

Now that we have set up a `git` user to handle all transport
methods, we need to set up the directory that we will be using as our
base of all repositories.

In my case, I am using `/git` as my source folder. To create
this folder and assign it to the user we created, execute the following
commands:

```sh
sudo mkdir /git
sudo chown -R git:git /git
```

### Creating a Test Repository

On your server, switch over to the `git` user in order to
start managing git files.

```sh
su git
```

Once logged-in as the `git` user, go to your base directory
and create a test repository.

```sh
cd /git
mkdir test.git && cd test.git
git init --bare
```

If you want to make this repo viewable/cloneable to the public via the
`git://` protocol, you need to create a
`git-daemon-export-ok` file inside the repository.

```sh
touch git-daemon-export-ok
```

# Change the Login Shell for `git`

To make sure that the `git` user is only used for git
operations and nothing else, you need to change the user\'s login shell.
To do this, simply use the `chsh` command:

```sh
sudo chsh git
```

The interactive prompt will ask which shell you want the
`git` user to use. You must use the following value:

```sh
/usr/bin/git-shell
```

Once done, no one will be able to SSH to the `git` user or
execute commands other than the standard git commands.

# Opening the Firewall

Don\'t forget to open up ports on the device firewall and network
firewall if you want to access these repositories publicly. If you\'re
using default ports, forward ports `22` (ssh) and
`9418` (git) from your router to your server\'s IP address.

If your server also has a firewall, ensure that the firewall allows the
same ports that are forwarded from the router. For example, if you use
`ufw`:

```sh
sudo ufw allow 22
sudo ufw allow 9418
```

## Non-Standard SSH Ports

If you use a non-standard port for SSH, such as `9876`, you
will need to create an SSH configuration file on your local development
machine in order to connect to your server\'s git repositories.

To do this, you\'ll need to define your custom port on your client
machine in your `~/.ssh/config` file:

```sh
nano ~/.ssh/config
```

``` conf
Host git.example.com
  # HostName can be a URL or an IP address
  HostName git.example.com
  Port 9876
  User git
```

## Testing SSH

There are two main syntaxes you can use to manage git over SSH:

-   `git clone [user@]server:project.git`
-   `git clone ssh://[user@]server/project.git`

I prefer the first, which is an `scp`-like syntax. To test
it, try to clone the test repository you set up on the server:

```sh
git clone git@git.example.com:/git/test.git
```

# Enabling Read-Only Access

If you want people to be able to clone any repository where you\'ve
placed a `git-daemon-export-ok` file, you will need to start
the git daemon.

To do this on a system with `systemd`, create a service file:

```sh
sudo nano /etc/systemd/system/git-daemon.service
```

Inside the `git-daemon.service` file, paste the following:

``` conf
[Unit]
Description=Start Git Daemon

[Service]
ExecStart=/usr/bin/git daemon --reuseaddr --base-path=/git/ /git/

Restart=always
RestartSec=500ms

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=git-daemon

User=git
Group=git

[Install]
WantedBy=multi-user.target
```

Once created, enable and start the service:

```sh
sudo systemctl enable git-daemon.service
sudo systemctl start git-daemon.service
```

To clone read-only via the `git://` protocol, you can use the
following syntax:

```sh
git clone git://git.example.com/test.git
```

# Migrating Repositories

At this point, we have a working git server that works with both SSH and
read-only access.

For each of the repositories I had hosted a different provider, I
executed the following commands in order to place a copy on my server as
my new source of truth:

Server:

```sh
su git
mkdir /git/<REPOSITORY_NAME>.git && cd /git/<REPOSITORY_NAME>.git
git init --bare

# If you want to make this repo viewable/cloneable to the public
touch git-daemon-export-ok
```

Client:

```sh
git clone git@<PREVIOUS_HOST>:<REPOSITORY_NAME>
git remote set-url origin git@git.EXAMPLE.COM:/git/<REPOSITORY_NAME>.git
git push
```

# Optional Web View: `cgit`

If you want a web viewer for your repositories, you can use various
tools, such as `gitweb`, `cgit`, or
`klaus`. I chose `cgit` due to its simple
interface and fairly easy set-up (compared to others). Not to mention
that the [Linux kernel uses `cgit`](https://git.kernel.org/).

## Docker Compose

Instead of using my previous method of using a `docker run`
command, I\'ve updated this section to use `docker-compose`
instead for an easier installation and simpler management and
configuration.

In order to use Docker Compose, you will set up a
`docker-compose.yml` file to automatically connect resources
like the repositories, `cgitrc`, and various files or folders
to the `cgit` container you\'re creating:

```sh
mkdir ~/cgit && cd ~/cgit
nano docker-compose.yml
```

``` conf
# docker-compose.yml
version: '3'

services:
  cgit:
    image: invokr/cgit
    volumes:
      - /git:/git
      - ./cgitrc:/etc/cgitrc
      - ./logo.png:/var/www/htdocs/cgit/logo.png
      - ./favicon.png:/var/www/htdocs/cgit/favicon.png
      - ./filters:/var/www/htdocs/cgit/filters
    ports:
      - "8763:80"
    restart: always
```

Then, just start the container:

```sh
sudo docker-compose up -d
```

Once it\'s finished installing, you can access the site at
`<SERVER_IP>:8763` or use a reverse-proxy service to forward
`cgit` to a URL, such as `git.example.com`. See
the next section for more details on reverse proxying a URL to a local
port.

## Nginx Reverse Proxy

I am using Nginx as my reverse proxy so that the `cgit`
Docker container can use `git.example.com` as its URL. To do
so, I simply created the following configuration file:

```sh
sudo nano /etc/nginx/sites-available/git.example.com
```

``` conf
server {
        listen 80;
          server_name git.example.com;

        if ($host = git.example.com) {
                return 301 https://$host$request_uri;
          }

          return 404;
}

server {
        server_name git.example.com;
        listen 443 ssl http2;

        location / {
                # The final `/` is important.
                    proxy_pass http://localhost:8763/;
                add_header X-Frame-Options SAMEORIGIN;
                add_header X-XSS-Protection "1; mode=block";
                proxy_redirect off;
                proxy_buffering off;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Port $server_port;
        }

        # INCLUDE ANY SSL CERTS HERE
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}
```

Once created, symlink it and restart the web server.

```sh
sudo ln -s /etc/nginx/sites-available/git.example.com /etc/nginx/sites-enabled/
sudo systemctl restart nginx.service
```

As we can see below, my site at `git.example.com` is
available and running:

## Settings Up Git Details

Once you have `cgit` running, you can add some small details,
such as repository owners and descriptions by editing the following
files within each repository.

Alternatively, you can use the `cgitrc` file to edit these
details if you only care to edit them for the purpose of seeing them on
your website.

The `description` file within the repository on your server
will display the description online.

```sh
cd /git/example.git
nano description
```

You can add a `[gitweb]` block to the `config`
file in order to display the owner of the repository.

```sh
cd /git/example.git
nano config
```

``` conf
[gitweb]
    owner = "YourName"
```

Note that you can ignore the configuration within each repository and
simply set up this information in the `cgitrc` file, if you
want to do it that way.

## Editing `cgit`

In order to edit certain items within `cgit`, you need to
edit the `cgitrc` file.

```sh
nano ~/cgit/cgitrc
```

Below is an example configuration for `cgitrc`. You can find
all the configuration options within the \[configuration manual\]
(<https://git.zx2c4.com/cgit/plain/cgitrc.5.txt>).

``` conf
css=/cgit.css
logo=/logo.png
favicon=/favicon.png
robots=noindex, nofollow

enable-index-links=1
enable-commit-graph=1
enable-blame=1
enable-log-filecount=1
enable-log-linecount=1
enable-git-config=1

clone-url=git://git.example.com/$CGIT_REPO_URL ssh://git@git.example.com:/git/$CGIT_REPO_URL

root-title=My Git Website
root-desc=My personal git repositories.

# Allow download of tar.gz, tar.bz2 and zip-files
snapshots=tar.gz tar.bz2 zip

##
## List of common mimetypes
##
mimetype.gif=image/gif
mimetype.html=text/html
mimetype.jpg=image/jpeg
mimetype.jpeg=image/jpeg
mimetype.pdf=application/pdf
mimetype.png=image/png
mimetype.svg=image/svg+xml

# Highlight source code
# source-filter=/var/www/htdocs/cgit/filters/syntax-highlighting.sh
source-filter=/var/www/htdocs/cgit/filters/syntax-highlighting.py

# Format markdown, restructuredtext, manpages, text files, and html files
# through the right converters
about-filter=/var/www/htdocs/cgit/filters/about-formatting.sh

##
## Search for these files in the root of the default branch of repositories
## for coming up with the about page:
##
readme=:README.md
readme=:readme.md
readme=:README.mkd
readme=:readme.mkd
readme=:README.rst
readme=:readme.rst
readme=:README.html
readme=:readme.html
readme=:README.htm
readme=:readme.htm
readme=:README.txt
readme=:readme.txt
readme=:README
readme=:readme

# Repositories

# Uncomment the following line to scan a path instead of adding repositories manually
# scan-path=/git

## Test Section
section=git/test-section

repo.url=test.git
repo.path=/git/test.git
repo.readme=:README.md
repo.owner=John Doe
repo.desc=An example repository!
```

## Final Fixes: Syntax Highlighting & README Rendering

After completing my initial install and playing around with it for a few
days, I noticed two issues:

1.  Syntax highlighting did not work when viewing the source code within
    a file.
2.  The `about` tab within a repository was not rendered to
    HTML.

The following process fixes these issues. To start, let\'s go to the
`cgit` directory where we were editing our configuration file
earlier.

```sh
cd ~/cgit
```

In here, create two folders that will hold our syntax files:

```sh
mkdir filters && mkdir filters/html-converters && cd filters
```

Next, download the default filters:

```sh
curl https://git.zx2c4.com/cgit/plain/filters/about-formatting.sh > about-formatting.sh
chmod 755 about-formatting.sh
curl https://git.zx2c4.com/cgit/plain/filters/syntax-highlighting.py > syntax-highlighting.py
chmod 755 syntax-highlighting.py
```

Finally, download the HTML conversion files you need. The example below
downloads the Markdown converter:

```sh
cd html-converters
curl https://git.zx2c4.com/cgit/plain/filters/html-converters/md2html > md2html
chmod 755 md2html
```

If you need other filters or html-converters found within [the cgit
project files](https://git.zx2c4.com/cgit/tree/filters), repeat the
`curl` and `chmod` process above for whichever
files you need.

However, formatting will not work quite yet since the Docker cgit
container we\'re using doesn\'t have the formatting package installed.
You can install this easily by install Python 3+ and the
`pygments` package:

```sh
# Enter the container's command line
sudo docker exec -it cgit bash
```

```sh
# Install the necessary packages and then exit
yum update -y &&                      \
yum upgrade -y &&                     \
yum install python3 python3-pip -y && \
pip3 install markdown pygments &&     \
exit
```

**You will need to enter the cgit docker container and re-run these
`yum` commands every time you kill and restart the
container!**

If not done already, we need to add the following variables to our
`cgitrc` file in order for `cgit` to know where
our filtering files are:

``` conf
# Highlight source code with python pygments-based highlighter
source-filter=/var/www/htdocs/cgit/filters/syntax-highlighting.py

# Format markdown, restructuredtext, manpages, text files, and html files
# through the right converters
about-filter=/var/www/htdocs/cgit/filters/about-formatting.sh
```

Now you should see that syntax highlighting and README rendering to the
`about` tab is fixed.

## Theming

I won\'t go into much detail in this section, but you can fully theme
your installation of `cgit` since you have access to the
`cgit.css` file in your web root. This is another file you
can add as a volume to the `docker-compose.yml` file if you
want to edit this without entering the container\'s command line.

### :warning: Remember to Back Up Your Data!

The last thing to note is that running services on your own equipment
means that you\'re assuming a level of risk that exists regarding data
loss, catastrophes, etc. In order to reduce the impact of any such
occurrence, I suggest backing up your data regularly.

Backups can be automated via `cron`, by hooking your base
directory up to a cloud provider, or even setting up hooks to push all
repository info to git mirrors on other git hosts. Whatever the method,
make sure that your data doesn\'t vanish in the event that your drives
or servers fail.
