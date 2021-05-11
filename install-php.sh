#!/bin/sh

apk add bzip2 file re2c freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq libwebp libzip

TMP="autoconf \
    bzip2-dev \
    freetds-dev \
    freetype-dev \
    g++ \
    gcc \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    make \
    openldap-dev \
    postgresql-dev"
apk add $TMP

# Configure extensions
docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp

# Download mongo extension
cd /tmp && \
    git clone https://github.com/mongodb/mongo-php-driver.git && \
    cd mongo-php-driver && \
    git submodule update --init && \
    phpize && \
    ./configure && \
    make all && \
    make install && \
    echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini && \
    rm -rf /tmp/mongo-php-driver

docker-php-ext-install \
    bcmath \
    bz2 \
    exif \
    gd \
    gettext \
    intl \
    ldap \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    zip

# Download trusted certs 
mkdir -p /etc/ssl/certs && update-ca-certificates

# Install composer
cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
	mv composer.phar /usr/bin/composer && \
	chmod +x /usr/bin/composer

# Install Xdebug
pecl install xdebug
echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/xdebug.ini

apk del $TMP

# Install PHPUnit
curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

# Set timezone
# RUN echo America/Maceio > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
