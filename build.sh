rm -rf .build/*                              && \
ENV=prod emacs --script publish.el           && \
scp -r .build/* ubuntu:/var/www/cleberg.net/
