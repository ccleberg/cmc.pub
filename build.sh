#!/bin/bash

printf "Did you update the 'Recent Blog Posts' section? [yn] "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ; then
	if [ "$ENV" == "prod" ]; then
		echo "Environment: Production"                   && \
		rm -rf .build/*                                  && \
		emacs --script publish.el &>/dev/null		 && \
		minify -o theme/static/styles.min.css		    \
		theme/static/styles.css				 && \
		pandoc -f org -t html readme.org  -o readme.html && \
		hut git update --readme readme.html --repo          \
		https://git.sr.ht/\~cyborg/cleberg.net           && \
		rsync -r --delete-before .build/*		    \
		ubuntu:/var/www/cleberg.net/
	else
		echo "Environment: Development"              && \
		rm -rf .build/*                              && \
		emacs --script publish.el		     && \
		minify -o theme/static/styles.min.css		\
		theme/static/styles.css			     && \
		cd .build/				     && \
		python3 -m http.server
	fi
else
	echo "Please update the 'Recent Blog Posts' section before publishing!"
fi
