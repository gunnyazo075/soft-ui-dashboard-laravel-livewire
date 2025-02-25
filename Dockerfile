FROM php:8.2-fpm

# Cập nhật và cài đặt các gói hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        intl \
        soap \
        zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài đặt extension Redis qua PECL
RUN pecl install redis \
    && docker-php-ext-enable redis

# (Tuỳ chọn) Cài đặt xdebug phục vụ gỡ lỗi (debug)
# RUN pecl install xdebug \
#     && docker-php-ext-enable xdebug

# Sao chép Composer từ image chính thức (Composer 2.x)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Đặt thư mục làm việc
WORKDIR /var/www

# Expose cổng cho PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
