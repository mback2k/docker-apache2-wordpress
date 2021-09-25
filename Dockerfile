FROM ghcr.io/mback2k/docker-apache2-php:latest

ARG PHP_VERSION=7.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php${PHP_VERSION}-gd php${PHP_VERSION}-curl \
        php${PHP_VERSION}-zip php${PHP_VERSION}-mysql && \
    apt-get install -y --no-install-recommends \
        msmtp msmtp-mta && \
    apt-get clean

RUN a2enmod rewrite headers env setenvif expires

RUN mkdir -p /var/www
WORKDIR /var/www

ARG WORDPRESS_VERSION=4.9.13

ADD https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz /var/www
RUN tar xfvz wordpress-${WORDPRESS_VERSION}.tar.gz

RUN chown root:root -R /var/www/wordpress
RUN chown www-data:www-data -R /var/www/wordpress/wp-content

RUN tar cfvz wordpress-content.tar.gz wordpress/wp-content
RUN chmod 640 wordpress-content.tar.gz

VOLUME /var/www/wordpress/wp-content

ENV WORDPRESS_DATABASE_HOST mysql
ENV WORDPRESS_DATABASE_NAME wordpress

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod 0755 /usr/local/bin/wp

ADD docker-entrypoint.d/ /run/docker-entrypoint.d/
ADD docker-websites.d/ /run/docker-websites.d/

HEALTHCHECK CMD killall -0 run-parts || curl http://localhost/wp-admin/admin-ajax.php | grep -e '^0$' || exit 1
