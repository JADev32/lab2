FROM public.ecr.aws/docker/library/php:8.0-apache

# Instalar dependencias del sistema y Composer
RUN apt-get update && apt-get install -y git unzip
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar Composer desde AWS ECR Public
COPY --from=public.ecr.aws/docker/library/composer:latest /usr/bin/composer /usr/bin/composer

# Crear estructura de directorios
RUN mkdir -p /var/www/html/config

# Copiar archivos específicamente (manejar archivos que pueden no existir)
COPY config/ /var/www/html/config/
COPY dic/ /var/www/html/dic/
COPY web/ /var/www/html/web/

# Copiar composer.json (requerido) y composer.lock si existe
COPY composer.json /var/www/html/
COPY composer.lock /var/www/html/ 2>/dev/null || echo "composer.lock no encontrado, continuando..."

WORKDIR /var/www/html

# Instalar dependencias de Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configuración de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY apache/default-site.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/ServerName example-app.com/ServerName localhost/' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 80