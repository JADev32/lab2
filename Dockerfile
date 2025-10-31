# 1️⃣ Base PHP + Apache ya disponible en Amazon Linux
FROM public.ecr.aws/amazonlinux/amazonlinux:2 as base

# Instalar PHP 8.0 y Apache
RUN amazon-linux-extras enable php8.0 \
    && yum install -y php php-cli php-mbstring httpd tar unzip \
    && yum clean all

# Crear directorio de la aplicación
WORKDIR /var/www/html

# 2️⃣ Instalar Composer manualmente sin usar Docker Hub
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 3️⃣ Copiar archivos de la aplicación
COPY . /var/www/html

# 4️⃣ Ajustar permisos
RUN chown -R apache:apache /var/www/html

# 5️⃣ Exponer puerto 80
EXPOSE 80

# 6️⃣ Comando de inicio
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
