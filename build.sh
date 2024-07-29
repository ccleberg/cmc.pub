#!/bin/bash

printf "Did you update the 'Recent Blog Posts' section? [yn] "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ; then
	if [ "$ENV" == "prod" ]; then
		echo "Environment = Production"              && \
		rm -rf .build/*                              && \
		emacs --script publish.el                    && \
		rsync -av --delete-before .build/* ubuntu:/var/www/cleberg.net/
	else
		echo "Environment = Development"             && \
		rm -rf .build/*                              && \
		emacs --script publish.el		     && \
		cd .build/				     && \
		python3 -m http.server
	fi
else
	echo No
fi
