FROM public.ecr.aws/docker/library/php:8.0-apache
#Prueba final?
# Instalar dependencias
RUN apt-get update && apt-get install -y git unzip curl
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar aplicación
COPY . /var/www/html/

WORKDIR /var/www/html

# Instalar dependencias PHP
RUN if [ -f "composer.json" ]; then composer install --no-dev --optimize-autoloader; fi

# Configuración BÁSICA de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Asegurar permisos
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Health check file - VERSIÓN MEJORADA
RUN echo '<?php' > /var/www/html/health.php
RUN echo 'header("Content-Type: text/plain");' >> /var/www/html/health.php
RUN echo 'http_response_code(200);' >> /var/www/html/health.php
RUN echo 'echo "OK";' >> /var/www/html/health.php
RUN echo '?>' >> /var/www/html/health.php

# Verificar que el archivo se creó
RUN ls -la /var/www/html/health.php
RUN cat /var/www/html/health.php

EXPOSE 80

CMD ["apache2-foreground"]