# Use an official Nginx runtime as the base image
FROM nginx:latest

# Install PHP 8-FPM and required extensions

RUN apt install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt update
RUN apt install php8.0    
RUN apt-get update && apt-get install -y \    
    php8.0-fpm \
    php8.0-mysql \
    php8.0-gd \
    php8.0-ldap \
    php8.0-xmlrpc \
    php8.0-curl \
    php8.0-intl \
    php8.0-apcu \
    php8.0-zip \
    php8.0-mbstring \
    php8.0-json \
    php8.0-xml \
    php8.0-imagick

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create a directory for GLPI and copy the GLPI files
RUN mkdir -p /var/www/html/glpi && \
    curl -L -o /tmp/glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz && \
    tar -xzf /tmp/glpi.tar.gz -C /var/www/html/glpi --strip-components=1 && \
    rm /tmp/glpi.tar.gz && \
    chown -R www-data:www-data /var/www/html/glpi

# Configure PHP-FPM for GLPI
COPY php-fpm-pool.conf /etc/php/8.0/fpm/pool.d/www.conf

# Expose ports
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["nginx", "-g", "daemon off;"]
