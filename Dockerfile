FROM php:7.3-fpm

RUN apt-get update && \
    apt-get install -y \
    zlib1g-dev libzip-dev sendmail

RUN echo "sendmail_path=/usr/sbin/sendmail -t -i" >> /usr/local/etc/php/conf.d/sendmail.ini 

RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install zip
    

RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint && \
    sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

RUN rm -rf /var/lib/apt/lists/*

