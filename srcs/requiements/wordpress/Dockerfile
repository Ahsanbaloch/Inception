FROM debian:bookworm

#update and upgrade the system
RUN apt-get update && apt-get install -y

#install required packages
RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

#copy the wordpress configuration script to the root directory in the container
COPY ./wp_conf.sh /

#permission to execute the script
RUN chmod +x /wp_conf.sh

#define the entrypoint
ENTRYPOINT ["/wp_conf.sh"]

