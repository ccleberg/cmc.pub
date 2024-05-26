#!/bin/bash

if [ "$ENV" == "prod" ]; then
	echo "Environment: Production"               && \
	rm -rf public/*                              && \
	zola build                                   && \
	rsync -avzP public/ ubuntu:/var/www/cleberg.net/
else
	echo "Environment: Development"              && \
	rm -rf public/*                              && \
	zola build                                   && \
	zola serve
fi
