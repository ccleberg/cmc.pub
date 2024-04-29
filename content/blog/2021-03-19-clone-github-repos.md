+++
date = 2021-03-19
title = "How to Clonse All Repositories from a GitHub or Sourcehut Account"
description = ""
draft = false
+++

# Cloning from GitHub

If you're like me and use a lot of different devices (and sometimes decide to
just wipe your device and start with a new OS), you probably know the pain of
cloning all your old code repositories down to your local file system.

If you're using GitHub, you can easily clone all of your code back down in just
seconds. First, create a bash script. I do so by opening a new file in `nano`,
but you can use `gedit`, `vim`, or something else:

```sh
nano clone_github_repos.sh
```

Next, paste in the following information. Note that you can replace the word
`users` in the first line with `orgs` and type an organization's name instead
of a user's name.

```sh
CNTX=users; NAME=YOUR-USERNAME; PAGE=1
curl "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
  grep -e 'git_url*' |
  cut -d " -f 4 |
  xargs -L1 git clone
```

Finally, save the bash script and make it executable.

```sh
chmod a+x clone_github_repos.sh
```

Now you can run the script and should see the cloning process begin.

```sh
./clone_github_repos.sh
```

# Cloning from Sourcehut

I haven't fully figured out how to directly incorporate Sourcehut's GraphQL
API into a bash script yet, so this one will take two steps.

First, log-in to Sourcehut and go to their [GraphQL playground for
Git](https://git.sr.ht/graphql). Next, paste the following query into the left
box:

```sh
query {
  me {
    canonicalName
    repositories() {
      cursor
      results {
        name
      }
    }
  }
}
```

The output on the right side will give you an object of all your repositories.
Just grab that text and remove all the characters such as quotation marks and
curly brackets. You will need a single-line list of space-separated values for
the next step.

Now let's create the bash script:

```sh
nano clone_sourcehut_repos.sh
```

Next, paste the following bash script in with the list of repositories you
obtained above and replace `your-username` with your username.

Note that this uses the SSH-based Git cloning method (e.g. `git@git...`), so
you'll need to ensure you have set up Sourcehut with your SSH key.

```sh
repos=(repo1 repo2 repo3)

# List all sub-directories in the current directory
for repo in "${repos[@]}"
do
    # Clone
    git clone git@git.sr.ht:~your-username/$repo
done
```

Finally, save the bash script and make it executable.

```sh
chmod a+x clone_sourcehut_repos.sh
```

Now you can run the script and should see the cloning process begin.

```sh
./clone_sourcehut_repos.sh
```

# Moving Repositories to a New Host

Now that you have all of your code repositories cloned to your local computer,
you may want to change the remote host (e.g., moving from GitHub to GitLab). To
do this, let's create another bash script:

```sh
nano change_remote_urls.sh
```

Past the following information and be sure to change the URL information to
whichever host you are moving to. For this example, I am looping through all of
my cloned GitHub directories and changing them to Sourcehut (e.g.
`<YOUR_NEW_REMOTE_URL>` -> `git@git.sr.ht:~myusername`).

```sh
# List all sub-directories in the current directory
for dir in */
do
    # Remove the trailing "/"
    dir=${dir%*/}
    # Enter sub-directory
    cd $dir
    # Change remote Git URL
    git remote set-url origin <YOUR_NEW_REMOTE_URL>/"${dir##*/}"
    # Push code to new remote
    git push
    # Go back to main directory
    cd ..
done
```

Finally, save the bash script and make it executable.

```sh
chmod a+x change_remote_urls.sh
```

Now you can run the script and should see the cloning process begin.

```sh
./change_remote_urls.sh
```
