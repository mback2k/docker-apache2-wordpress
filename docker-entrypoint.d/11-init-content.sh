#!/bin/sh
set -e

if [ ! -d "wordpress/wp-content" ]; then
    mkdir wordpress/wp-content
fi

if [ ! -f "wordpress/wp-content/index.php" ]; then
    tar xfvz wordpress-content.tar.gz
fi

exit 0
