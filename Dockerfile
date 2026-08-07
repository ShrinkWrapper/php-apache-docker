ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-apache

COPY user.ini /usr/local/etc/php/conf.d/

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions zip mysqli gd exif intl imagick

RUN apt-get update && apt-get install -y \
    less \
    nano \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite remoteip ;\
    {\
     echo RemoteIPHeader X-Real-IP ;\
     echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
     echo RemoteIPTrustedProxy 172.16.0.0/16 ;\
     echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
    } > /etc/apache2/conf-available/remoteip.conf;\
    a2enconf remoteip