FROM arm64v8/ubuntu:noble

# Copy data-sync files.

COPY . .

# Add crontab file in the cron directory

ADD ./crontab /etc/cron.d/data-sync-cron

# Give execution rights on the cron job

RUN chmod 0644 /etc/cron.d/data-sync-cron

# Create the log file to be able to run tail

RUN touch /var/log/cron.log

#Install Cron
RUN apt update && apt -y upgrade
RUN apt -y install cron php git zip unzip php-zip vim mariadb-server

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv composer.phar /usr/local/bin/composer

RUN composer install

# Run the command on container startup

CMD printenv > /etc/environment && cron && tail -f /var/log/cron.log