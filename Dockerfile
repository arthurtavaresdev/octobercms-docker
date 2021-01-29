# PHP 7.4 Apache
FROM php:7.4-apache

# Set working directory
WORKDIR /var/www/html

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

# Add NodeSource
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Install dependencies
RUN apt-get -yqq update && apt-get -yqq install \
    build-essential \
    g++ \
    gifsicle \
    git \
    gnupg2 \
    graphviz \
    jpegoptim \
    libbz2-dev \
    libc-client2007e-dev \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpq-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    libzip-dev \
    nodejs \
    openssl \
    unzip \
    zip \
    zlib1g-dev \
    libwebp-dev

# Install PECL extensions
RUN pecl install \
    imagick \
    mcrypt-1.0.4 \
    redis \
    xdebug

RUN docker-php-ext-enable \
    imagick \
    mcrypt \
    redis \
    xdebug

# Configure php extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure intl

# Enable apache mods
RUN a2enmod rewrite
RUN a2enmod headers

# Install php extension
RUN docker-php-ext-install \
    exif \
    gd \
    gmp \
    imap \
    intl \
    mbstring \
    pdo \
    pdo_mysql \
    pcntl \
    soap \
    zip

# Install composer
COPY --from=composer:1 /usr/bin/composer /usr/local/bin/composer

# TODO remove prestissimo when composer hits v2
RUN composer global require hirak/prestissimo --no-plugins --no-scripts
