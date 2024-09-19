FROM php:8.2-fpm

# php 와 연동해서 필요한 것
RUN apt-get update && apt-get install -y \
        zlib1g-dev \
        libmcrypt-dev \
        libpq-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \
        libzip-dev \
        zip

# 주요 php extention 설치
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install zip

# composer 설치
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

# mysql db extention install
RUN docker-php-ext-install mysqli pdo pdo_mysql

# redis 설치
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# 지역 정보 수정
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone
    
# php config file copy
COPY php_init.ini /usr/local/etc/php/conf.d/php_init.ini
