FROM php:7-apache

COPY config.php /var/www/html/config/config.php

RUN apt-get update \
    && apt-get install -y \
		wget zip unzip \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        sqlite3 libsqlite3-dev \
        libssl-dev \
    && pecl install mongodb \
    && pecl install redis \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) iconv gd pdo zip opcache pdo_sqlite \
    && a2enmod rewrite expires

RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html

CMD ["apache2-foreground"]
