FROM php:8.2-fpm

# تثبيت الأدوات والحزم المطلوبة مع Node.js و npm
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libonig-dev libxml2-dev libpq-dev nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

# تثبيت الاعتماديات
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8000

CMD chmod +x build.sh && ./build.sh && php artisan serve --host=0.0.0.0 --port=8000