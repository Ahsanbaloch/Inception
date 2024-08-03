FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client iputils-ping

# Copy the wordpress configuration script to the root directory in the container
COPY ./wp-conf.sh /

RUN chmod +x wp-conf.sh

ENTRYPOINT ["./wp-conf.sh"]