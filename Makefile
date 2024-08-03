#define the path
WP_DATA = /Home/data/wordpress  
DB_DATA = /Home/data/mariadb

all: up

# start the biulding process
# create the wordpress and mariadb data directories.
# start the containers in the background and leaves them running
up: build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker-compose -f ./docker-compose.yml up -d

down:
	docker-compose -f ./docker-compose.yml down

stop:
	docker-compose -f ./docker-compose.yml stop

start:
	docker-compose -f ./docker-compose.yml start

build:
	docker compose -f ./docker-compose.yml build

#clean the containers
#stop all running containers and remove them.
#remove all images, volumes and networks.
#remove the wordpress and mariadb data directories.
#the (|| true) is used to ignore the error if there are no containers running to prevent the make command from stopping.
clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
# @read -p "Are you sure you want to remove the wordpress and mariadb data directories? [y/N] " 
# confirm && [[ $$confirm == [yY] || $$confirm == [yY][eE][sS] ]] || exit 1
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

re: clean up

prune: clean
	@docker system prune -a --volumes -f

.PHONY: up down stop start build ng mdb wp clean re prune