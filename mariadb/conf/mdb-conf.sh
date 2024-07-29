#!bin/bash

#start mariadb
service mariadb start
sleep 5 # wait for mariadb to start

#config mariadb
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

#create user
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

#Grant privileges to user
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"


#Flush privileges to apply changes
mariadb -e "FLUSH PRIVILEGES;"

#restart mariadb
#shutdown mariadb to restart with new configuration
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

#Restart mariadb with new configuration in background to keep container running
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'

