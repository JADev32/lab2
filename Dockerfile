FROM public.ecr.aws/docker/library/php:8.0-apache

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

# Configuración de Apache MEJORADA
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Configurar DocumentRoot si es necesario (si tu app está en subdirectorio 'web')
RUN if [ -d "/var/www/html/web" ]; then \
        sed -i 's|/var/www/html|/var/www/html/web|g' /etc/apache2/sites-available/000-default.conf; \
    fi

# Permisos MEJORADOS
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
RUN find /var/www/html -type f -exec chmod 644 {} \;

# Health check file
RUN echo '<?php http_response_code(200); echo "OK"; ?>' > /var/www/html/health.php

# Verificar estructura de archivos
RUN echo "=== Estructura de archivos ===" && ls -la /var/www/html/

EXPOSE 80

CMD ["apache2-foreground"]