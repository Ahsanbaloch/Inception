FROM debian:bookworm

#update and upgrade the system
RUN apt-get update && apt-get install -y

RUN apt-get install -y nginx openssl

RUN mkdit -p /etc/nginx/ssl

#generate the ssl certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/nginx.crt -keyout \
     /etc/nginx/ssl/nginx.key -subj "/C=MO/ST=KH/L=KH/O=42/OU=42/CN=ahsalam.42.fr/UID=ahsalam" #change contry and other values

#copy the configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf

#create wordpress directory
RUN mkdir -p /var/www/wordpress

#change the owner of the wordpress directory to www-data
RUN chown -R www-data:www-data /var/www/wordpress

#define the command to run when the container starts
CMD ["nginx", "-g", "daemon off;"]
