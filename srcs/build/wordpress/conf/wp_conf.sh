#!/bin/bash

#wp installation

curl -o https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#wp-cli permission
chmod +x wp-cli.phar

#wp-cli move to bin
mv wp--cli.phar /usr/local/bin/wp

#go to the wordpress directory
cd /var/www/wordpress

#wordpress directory permission
chmod -R 755 /var/www/wordpress/

#change the owner of wordpress directory
chown -R www-data:www-data /var/www/wordpress

#ping mariadb
#check if mariadb is running
ping_mariadb_container()
{
    nc -zv mariadb 3306 > /dev/null  #ping mariadb container
    return $? #return the status of the ping
}

