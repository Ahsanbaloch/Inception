#!/bin/bash

#wp-cli installation
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#wp-cli permission
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress

chmod -R 755 /var/www/wordpress/

#change owner of wordpress directory to www-data
chown -R www-data:www-data /var/www/wordpress

#check if mariadb container is up and running
ping_mariadb_container() {
    ping -c 1 mariadb > /dev/null #ping the mariadb container
    return $?
}

start_time=$(date +%s) #get the current time in seconds
end_time=$((start_time + 20)) #set the end time to 20 seconds after the start time

while [ $(date +%s) -lt $end_time ]; do #loop until the current time is greater than the end time
    ping_mariadb_container #Ping the MariaDB container
    if [ $? -eq 0 ]; then #check if the ping was successful
        echo "MARIADB IS UP AND RUNNING"
        break #exit the loop if MariaDB is up
    else
        echo "WAITING FOR MARIADB TO START..."
        sleep 1 #wait for 1 second before trying again
    fi
done

if [ $(date +%s) -ge $end_time ]; then #check if the current time is greater than or equal to the end time
    echo "MARIADB IS NOT RESPONDING"
fi

#install wordpress
wp core download --allow-root
# create wp-config.php file with database details
wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
# install wordpress with the given title, admin username, password and email
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
# create a new user with the given username, email, password and role
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

#config for php
#change listen port from unix socket to 9000
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
#create a directory for php-fpm
mkdir -p /run/php
#start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm7.4 -F