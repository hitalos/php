FROM php
LABEL maintainer="hitalos <hitalos@gmail.com>"

RUN apt-get update && apt-get -y full-upgrade && apt-get install -y bash git

# Install PHP extensions
ADD install-php.sh /usr/sbin/install-php.sh
RUN /usr/sbin/install-php.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www
CMD ["/usr/local/bin/php"]
