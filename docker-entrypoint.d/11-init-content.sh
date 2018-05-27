#!/bin/sh
set -e

cd /var/www/wordpress

if [ ! -d "wp-content" ]; then
    mkdir wp-content
fi

if [ ! -f "wp-content/index.php" ]; then
    tar xfvz wordpress-content.tar.gz
fi

exit 0
