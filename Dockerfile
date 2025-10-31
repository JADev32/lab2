FROM public.ecr.aws/docker/library/php:8.0-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y git unzip
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar aplicación
COPY . /var/www/html/

WORKDIR /var/www/html

# Instalar dependencias PHP
RUN if [ -f "composer.json" ]; then composer install --no-dev --optimize-autoloader; fi

# Configurar Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80