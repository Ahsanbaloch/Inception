#Dockerfile for MariaDB

#pull base image
FROM debian:bookworm

#update and upgrade the system
RUN apt-get update && apt-get install -y 

#install mariadb
RUN apt-get install -y mariadb-server

#Copy file from host to container
COPY ./mdb-conf.sh /mdb-conf.sh

#permission to execute the file
RUN chmod +x /mdb-conf.sh

#define entrypoint to run the script
ENTRYPOINT ["/mdb-conf.sh"]