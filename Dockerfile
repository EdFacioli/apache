FROM ubuntu:16.04
MAINTAINER Dhanu Gupta <dhanu.gupta@gmail.com>

RUN apt-get update
RUN apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 && apt-get clean

# Enable apache mods.
#RUN php5enmod openssl
#RUN a2enmod php5
#RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

WORKDR /var/www/html

# Copy site into place.
ADD http://www.proredetelecom.com.br/docker/logo.jpg /var/www/html
ADD http://www.proredetelecom.com.br/docker/index.html /var/www/html
ADD http://www.proredetelecom.com.br/docker/styles.css /var/www/html

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD ["apache2ctl", "-D",  "FOREGROUND"]
