#!/bin/bash

if [ "$ENV" == "prod" ]; then
	echo "Environment = Production"              && \
	rm -rf .build/*                              && \
	emacs --script publish.el                    && \
	scp -r .build/* ubuntu:/var/www/cleberg.net/
else
	echo "Environment = Development"             && \
	rm -rf .build/*                              && \
	emacs --script publish.el
fi
