#!/bin/bash

# Ensure the latest post is included on the home page
printf "Did you update the 'Recent Blog Posts' section? [yn] "
read answer

# Only continue if latest post is included on the home page
if [[ "$answer" =~ ^[Yy]$ ]]; then
    # Check if the environment flag is set to PROD
    if [[ "$ENV" == "prod" ]]; then
        echo "Environment: Production"
        
        # Check if publishing via LAN or remotely
        printf "Publishing on remote or LAN? [r|l] "
        
        # Update ubuntu_server variable based on answer
        read method
        if [[ "$method" =~ ^[Rr]$ ]]; then
            ubuntu_server="ubuntu-remote"
        elif [[ "$method" =~ ^[Ll]$ ]]; then
            ubuntu_server="ubuntu"
        else
            echo "Invalid input. Assuming LAN (ubuntu)"
            ubuntu_server="ubuntu"
        fi
        
        # Remove previous build
        rm -rf .build/*
        
        # Run publishing script
        emacs --script publish.el &>/dev/null
        
        # Minify CSS
        minify -o theme/static/styles.min.css theme/static/styles.css
        
        # Deploy changes
        rsync -r --delete-before .build/* $ubuntu_server:/var/www/cleberg.net/
    else
        echo "Environment: Development"
        
        # Remove previous build
        rm -rf .build/*
        
        # Run publishing script
        emacs --script publish.el
        
        # Minify CSS
        minify -o theme/static/styles.min.css theme/static/styles.css

        # Launch development web server
        cd .build/
        python3 -m http.server
    fi
else
    echo "Please update the 'Recent Blog Posts' section before publishing!"
fi
