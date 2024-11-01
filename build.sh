#!/bin/bash

printf "Did you update the 'Recent Blog Posts' section? [yn] "
read answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    printf "Publishing on remote or LAN? [r|l] "
    read method
    
    if [[ "$method" =~ ^[Rr]$ ]]; then
        ubuntu_server="ubuntu-remote"
    elif [[ "$method" =~ ^[Ll]$ ]]; then
        ubuntu_server="ubuntu"
    else
        echo "Invalid input. Assuming LAN (ubuntu)"
        ubuntu_server="ubuntu"
    fi
    
    if [[ "$ENV" == "prod" ]]; then
        echo "Environment: Production"
        rm -rf .build/*
        emacs --script publish.el &>/dev/null
        minify -o theme/static/styles.min.css theme/static/styles.css
        rsync -r --delete-before .build/* $ubuntu_server:/var/www/cleberg.net/
    else
        echo "Environment: Development"
        rm -rf .build/*
        emacs --script publish.el
        minify -o theme/static/styles.min.css theme/static/styles.css
        cd .build/
            python3 -m http.server
    fi
else
    echo "Please update the 'Recent Blog Posts' section before publishing!"
fi
