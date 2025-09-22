FROM php:8.1-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir directorio de trabajo
WORKDIR /var/www/html

# Copiar composer.json y composer.lock (si existe)
COPY composer.json composer.lock* ./

# Instalar dependencias PHP evitando problemas de git y root
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install \
    --no-dev \
    --optimize-autoloader \
    --prefer-dist \
    --no-scripts \
    --no-interaction

# Copiar el resto de la aplicación
COPY . .

# Habilitar mod_rewrite y configurar VirtualHost
RUN a2enmod rewrite && \
    echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Asignar permisos correctos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Generar key y cachear configuración en runtime (no en build)
# Esto es mejor hacerlo en un entrypoint para no invalidar el build cada vez
# Por ahora lo dejamos como opcional
# RUN php artisan key:generate --force || true
# RUN php artisan config:cache || true

# Exponer puerto 80
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]
