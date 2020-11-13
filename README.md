![Docker Pulls](https://img.shields.io/docker/pulls/hitalos/php.svg)

# PHP
Docker image to run basic PHP projects.

This image it's for development. **Optimize to use in production!**

## Tags
* [**`latest`**](https://github.com/hitalos/php/blob/master/Dockerfile): For simple projects with faster deploy.
* [**`debian`**](https://github.com/hitalos/php/blob/debian/Dockerfile): For more complex projects. This larger image brings compilers and other packages.

## Versions
* `php` 7.4.12
  * `composer` 2.0.7
  * `phpunit` 9.4.3
  * `xdebug` 2.9.8

## Supported Databases (**PDO**)
* `mssql` (via dblib)
* `mysql`
* `pgsql`
* `sqlite`

## Extra supported extensions
* `curl`
* `exif`
* `gd`
* `ldap`
* `mongodb`

## Installing
    docker pull hitalos/php

## Using

### With `docker`
    docker run --name <container_name> -d -v $PWD:/var/www -p 80:80 hitalos/php
Where $PWD is the project folder.

### With `docker-compose`

Create a `docker-compose.yml` file in the root folder of project using this as a template:
```
web:
    image: hitalos/php:latest
    ports:
        - 80:80
    volumes:
        - ./:/var/www
    command: php -S 0.0.0.0:80 -t public public/index.php
```

Then run using this command:

    docker-compose up


If you want to use a database, you can create your `docker-compose.yml` with two containers.
```
web:
    image: hitalos/php:latest
    ports:
        - 80:80
    volumes:
        - ./:/var/www
    links:
        - db
    environment:
        DB_HOST: db
        DB_DATABASE: dbname
        DB_USERNAME: username
        DB_PASSWORD: p455w0rd
        DB_CONNECTION: [pgsql, mysql or mariadb]
db:
    image: [postgres, mysql or mariadb]
    environment:
        # with mysql
        MYSQL_DATABASE: dbname
        MYSQL_USER: username
        MYSQL_PASSWORD: p455w0rd

        # with postgres
        POSTGRES_DB: dbname
        POSTGRES_USER: username
        POSTGRES_PASSWORD: p455w0rd
```
