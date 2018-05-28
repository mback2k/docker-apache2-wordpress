#!/bin/bash

if [ -f "${WORDPRESS_DATABASE_PASS_FILE}" ]; then
    WORDPRESS_DATABASE_PASS="$(< "${WORDPRESS_DATABASE_PASS_FILE}")"
fi

if [ -f "${WORDPRESS_ADMIN_PASS_FILE}" ]; then
    WORDPRESS_ADMIN_PASS="$(< "${WORDPRESS_ADMIN_PASS_FILE}")"
fi

if [ -n "${WORDPRESS_DATABASE_HOST}" ]; then
if [ -n "${WORDPRESS_DATABASE_NAME}" ]; then
if [ -n "${WORDPRESS_DATABASE_USER}" ]; then
if [ -n "${WORDPRESS_DATABASE_PASS}" ]; then
    echo "${WORDPRESS_DATABASE_PASS}" | \
    runuser -u www-data -- /bin/sh -c 'cd /var/www/wordpress; wp config create \
        --dbhost="${WORDPRESS_DATABASE_HOST}" --dbname="${WORDPRESS_DATABASE_NAME}" \
        --dbuser="${WORDPRESS_DATABASE_USER}" --prompt=dbpass --force --skip-check'
fi
fi
fi
fi

if [ -n "${WORDPRESS_URL}" ]; then
if [ -n "${WORDPRESS_TITLE}" ]; then
if [ -n "${WORDPRESS_ADMIN_USER}" ]; then
if [ -n "${WORDPRESS_ADMIN_PASS}" ]; then
if [ -n "${WORDPRESS_ADMIN_MAIL}" ]; then
    runuser -u www-data -- /bin/sh -c 'cd /var/www/wordpress; wp core is-installed'
    if [ $? -eq 0 ]; then exit 0; fi
    runuser -u www-data -- /bin/sh -c 'cd /var/www/wordpress; wp core install \
        --url="${WORDPRESS_URL}" --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASS}" \
        --admin_email="${WORDPRESS_ADMIN_MAIL}"'
fi
fi
fi
fi
fi

unset WORDPRESS_DATABASE_PASS
unset WORDPRESS_ADMIN_PASS

exit 0
