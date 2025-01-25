# install-hooks.sh
#!/bin/bash
cp utils/hooks/* .git/hooks/
chmod +x .git/hooks/*
