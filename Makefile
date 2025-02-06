include srcs/.env  # Load variables from .env

DATA_DIR ?= /home/$(LOGIN)/data
COMPOSE_FILE := srcs/docker-compose.yml

WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress

all: up

up: prepare
	docker compose -f $(COMPOSE_FILE) up --build $(ARGS)

prepare:
	echo  $(WORDPRESS_DATA_DIR)
	@mkdir -p $(WORDPRESS_DATA_DIR)

stop:
	docker compose -f $(COMPOSE_FILE) stop

down:
	docker compose -f $(COMPOSE_FILE) down

del:
	docker stop $$(docker ps -aq) 2>/dev/null || true
	docker rm $$(docker ps -aq) 2>/dev/null || true
	docker rmi $$(docker images -aq) 2>/dev/null || true
	docker volume prune -f
	docker container prune -f
	docker system prune --all --force --volumes
	docker volume rm -f $$(docker volume ls | grep -v DRIVER | tr -s " " | cut -d " " -f 2 | tr "\n" " ") 2>/dev/null || true

.PHONY: up prepare stop down del