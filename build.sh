#!/bin/bash

if [ "$ENV" == "prod" ]; then
	echo "Environment: Production"               && \
	rm -rf .build/*                              && \
	zola build                                   && \
	rsync -avzP .build/ ubuntu:/var/www/cleberg.net/
else
	echo "Environment: Development"              && \
	rm -rf .build/*                              && \
	zola build                                   && \
	zola serve
fi
