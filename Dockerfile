﻿FROM public.ecr.aws/docker/library/php:8.0-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y git unzip curl
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar aplicación - PRIMERO config/ EXPLÍCITAMENTE
COPY config/ /var/www/html/config/
COPY dic/ /var/www/html/dic/
COPY web/ /var/www/html/web/
COPY src/ /var/www/html/src/
COPY composer.json /var/www/html/
COPY composer.lock /var/www/html/ 2>/dev/null || echo "composer.lock no existe"
COPY autoloader.php /var/www/html/
COPY bootstrap.php /var/www/html/
COPY error_handler.php /var/www/html/

WORKDIR /var/www/html

# Instalar dependencias PHP
RUN if [ -f "composer.json" ]; then composer install --no-dev --optimize-autoloader; fi

# Configuración de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN sed -i 's|/var/www/html|/var/www/html/web|g' /etc/apache2/sites-available/000-default.conf

# Permisos
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Health check
RUN echo '<?php http_response_code(200); echo "OK"; ?>' > /var/www/html/web/health.php

EXPOSE 80

CMD ["apache2-foreground"]