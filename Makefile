COMPOSE_FILE := srcs/docker-compose.yml

# TODO: remove docker/docker-compose install docker desktop in the 42 VM to keep docker compose working

all:
	docker compose -f $(COMPOSE_FILE) up

re:
	docker compose -f $(COMPOSE_FILE) up --build $(ARGS)

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
