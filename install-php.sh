#!/bin/sh

TMP="autoconf \
    freetds-dev \
    g++ \
    gcc \
    libcrypto++-dev \
    libfreetype6-dev \
    libicu-dev \
    libldap2-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libwebp-dev \
    libxml2-dev \
    make"
apt-get install -y freetds-bin $TMP

# Configure extensions
docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
docker-php-ext-configure ldap --with-libdir=lib/
docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu/

# Download mongo extension
/usr/local/bin/pecl download mongodb && \
    tar -C /usr/src/php/ext -xf mongo*.tgz && \
    rm mongo*.tgz && \
    mv /usr/src/php/ext/mongo* /usr/src/php/ext/mongodb

docker-php-ext-install \
    exif \
    gd \
    gettext \
    intl \
    ldap \
    mongodb \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    xmlrpc \
    zip

# Download trusted certs 
mkdir -p /etc/ssl/certs && update-ca-certificates

# Install composer
php -r "readfile('https://getcomposer.org/installer');" | php && \
   mv composer.phar /usr/bin/composer && \
   chmod +x /usr/bin/composer

# Install Xdebug
XDEBUG_VERSION=2.6.1
curl -sSL -o /tmp/xdebug-${XDEBUG_VERSION}.tgz http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz
cd /tmp && tar -xzf xdebug-${XDEBUG_VERSION}.tgz && cd xdebug-${XDEBUG_VERSION} && phpize && ./configure && make && make install
echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/xdebug.ini
rm -rf /tmp/xdebug*

apt-get purge -y $TMP

# Install PHPUnit
curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

# Set timezone
# RUN echo America/Maceio > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
