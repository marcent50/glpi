# Use an official Nginx runtime as the base image
FROM debian:11.6
# Install PHP 8-FPM and required extensions

RUN apt update \
&& apt install --yes ca-certificates apt-transport-https lsb-release wget curl \
&& curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \ 
&& sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
&& apt update \
&& apt install --yes --no-install-recommends \
&& apt install nginx -y \
&& apt install supervisor -y \
php8.1 \
php8.1-mysql \
php8.1-fpm \
php8.1-ldap \
php8.1-xmlrpc \
php8.1-imap \
php8.1-curl \
php8.1-gd \
php8.1-mbstring \
php8.1-xml \
php-cas \
php8.1-intl \
php8.1-zip \
php8.1-bz2 \
php8.1-redis \
cron \
jq \
libldap-2.4-2 \
libldap-common \
libsasl2-2 \
libsasl2-modules \
libsasl2-modules-db \
&& rm -rf /var/lib/apt/lists/*


WORKDIR /tmp
RUN curl -L -o /tmp/glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz

# Extract the archive
RUN tar -xzf /tmp/glpi.tar.gz

# Remove the downloaded archive
RUN rm /tmp/glpi.tar.gz
RUN chmod 777 -R glpi
#RUN cp -r glpi /var/www/html/
# Copy Nginx configuration
COPY glpi-nginx.conf /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default
COPY supervisord.conf /etc/supervisor/conf.d/

# Create a directory for GLPI and copy the GLPI files
# Download GLPI archive

    #chown -R www-data:www-data /var/www/html/glpi

# Configure PHP-FPM for GLPI#
#COPY php-fpm-pool.conf /etc/php/8.0/fpm/pool.d/www.conf

# Expose ports
EXPOSE 80

# Start Nginx and PHP-FPM
#CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]


