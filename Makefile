# Define the paths
WP_DATA = /home/data/wordpress  
DB_DATA = /home/data/mariadb
COMPOSE_FILE = ./docker-compose.yml

all: up

# Start the building process
# Create the WordPress and MariaDB data directories.
# Start the containers in the background and leave them running.
up: 
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker-compose up --build
#-f $(COMPOSE_FILE) up -d

# Stop and remove all containers, networks, images, and volumes
down:
	docker-compose -f $(COMPOSE_FILE) down --rmi all -v --remove-orphans

# Stop all running containers
stop:
	docker-compose -f $(COMPOSE_FILE) stop

# Start all stopped containers
start:
	docker-compose -f $(COMPOSE_FILE) start

# Build or rebuild services
build:
	docker-compose -f up --build

# Clean the environment
# Stop all running containers and remove them.
# Remove all images, volumes, and networks.
# Remove the WordPress and MariaDB data directories.
clean:
	@docker-compose -f $(COMPOSE_FILE) down --rmi all -v --remove-orphans || true
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

# Rebuild the environment
re: clean up

# Prune the system
# Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
prune: clean
	@docker system prune -a --volumes -f || true

.PHONY: up down stop start build clean re prune


https://github.com/MarouanDoulahiane/inception-42/blob/main/srcs/docker-compose.yml