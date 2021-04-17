FROM ubuntu

# Install dependencies and set timezone to UTC
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y tzdata
ENV TZ "UTC"
RUN echo "UTC" > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y git wget python cron ffmpeg curl apache2 php libapache2-mod-php php-mysql php-xml php-zip php-gd
RUN wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
RUN chmod a+rx /usr/bin/youtube-dl
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/UCT /etc/localtime

# Install app

# Download codepoet80's wrapper and configure it
RUN rm -rf /var/www/html/*
RUN cd /tmp; git clone https://github.com/codepoet80/metube-php-servicewrapper
RUN mv /tmp/metube-php-servicewrapper/* /var/www/html/
RUN wget https://raw.githubusercontent.com/h8pewou/legacy_webos/main/metube-webos-config.php -O /var/www/html/config.php

# Downloads clean-up
RUN mkdir /downloads/
RUN chown -R www-data:www-data /downloads/
RUN echo "find /downloads/*.mp4 -amin +60 -exec rm -f {} \;" > /etc/cron.hourly/youtube-cleanup
RUN chmod a+rx /etc/cron.hourly/youtube-cleanup

# Configure apache

RUN rm -f /etc/apache2/sites-available/000-default.conf
RUN wget https://raw.githubusercontent.com/h8pewou/legacy_webos/main/000-default.conf -O /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html/
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

RUN echo "rm -f /var/run/apache2/apache2.pid" > /run.sh
RUN echo "apachectl -DFOREGROUND" >> /run.sh
RUN chmod a+rx /run.sh
CMD ["/bin/bash", "/run.sh"]
