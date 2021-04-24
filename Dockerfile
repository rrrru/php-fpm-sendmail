FROM php:7.3-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    zlib1g-dev libzip-dev sendmail mariadb-client \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libzip-dev

RUN echo "sendmail_path=/usr/sbin/sendmail -t -i" >> /usr/local/etc/php/conf.d/sendmail.ini 

RUN pecl install imagick-3.4.4 && \
    docker-php-ext-enable imagick

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install pdo_mysql zip mbstring exif mbstring

RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint && \
    sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
  chmod +x wp-cli.phar; \
  mv wp-cli.phar /usr/local/bin/wp;

RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/pear

