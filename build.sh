#!/bin/sh

cd ~/Source/cleberg.net/
rm -rf public/
zola build --force
scp -r public/* ubuntu:/var/www/cleberg.net/
