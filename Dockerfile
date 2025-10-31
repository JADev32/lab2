FROM public.ecr.aws/docker/library/php:8.0-apache

#cambio para testear

# Instalar dependencias
RUN apt-get update && apt-get install -y git unzip curl
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar aplicación (EXCLUYENDO la configuración problemática de Apache)
COPY . /var/www/html/

WORKDIR /var/www/html

# Instalar dependencias PHP
RUN if [ -f "composer.json" ]; then composer install --no-dev --optimize-autoloader; fi

# Configuración BÁSICA de Apache (sin archivos externos problemáticos)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Asegurar permisos
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Health check file
RUN echo "<?php http_response_code(200); echo 'OK'; ?>" > /var/www/html/health.php

EXPOSE 80

# Mantener Apache ejecutándose
CMD ["apache2-foreground"]