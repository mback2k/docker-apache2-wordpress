FROM mback2k/apache2-php

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php7.0-gd php7.0-curl php7.0-zip \
        php7.0-mysql php7.0-opcache && \
    apt-get install -y --no-install-recommends \
        msmtp msmtp-mta && \
    apt-get clean

RUN a2enmod rewrite headers env setenvif expires

RUN mkdir -p /var/www
WORKDIR /var/www

ARG WORDPRESS_VERSION=4.9.10

ADD https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz /var/www
RUN tar xfvz wordpress-${WORDPRESS_VERSION}.tar.gz

RUN chown root:root -R /var/www/wordpress
RUN chown www-data:www-data -R /var/www/wordpress/wp-content

RUN tar cfvz wordpress-content.tar.gz wordpress/wp-content
RUN chmod 640 wordpress-content.tar.gz

VOLUME /var/www/wordpress/wp-content

ADD opcache-recommended.ini /etc/php/7.0/cli/conf.d/99-opcache-recommended.ini
ADD opcache-recommended.ini /etc/php/7.0/apache2/conf.d/99-opcache-recommended.ini

ENV WORDPRESS_DATABASE_HOST mysql
ENV WORDPRESS_DATABASE_NAME wordpress

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod 0755 /usr/local/bin/wp

ADD docker-entrypoint.d/ /run/docker-entrypoint.d/
ADD docker-websites.d/ /run/docker-websites.d/

HEALTHCHECK CMD curl http://localhost/wp-admin/admin-ajax.php | grep -e '^0$' || exit 1
