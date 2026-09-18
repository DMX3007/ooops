CONTAINER_NAME = junior-devops-app
IMAGE_NAME = junior-devops-app:latest
.DEFAULT_GOAL := help

.PHONY: ps
ps: ## see docker processes
	@docker ps

.PHONY: build
build: ## build docker image
	@docker build -t junior-devops-app .

.PHONY: up
up: ## up containers
	@docker compose --env-file .env up -d

.PHONY: down
down: ## down containers
	@docker compose --env-file .env down

.PHONY: logs
logs: ## see docker logs
	@docker compose logs -f
.PHONY: backup
backup: ## do backups
	@./backup.sh

.PHONY: terminal
terminal: ## go into container
	@docker exec -it $(CONTAINER_NAME) /bin/sh

.PHONY: destroy
destroy: ## stop container, remove image and volumes
	@docker compose --env-file .env down --volumes
	@if [ -n "$$(docker images -q $(IMAGE_NAME))" ]; then \
		docker rmi $(IMAGE_NAME); \
	else \
		echo "Образ $(IMAGE_NAME) уже удален или не существовал."; \
	fi

.PHONY: hc
hc: ## check detailed healthcheck logs
	@docker inspect --format='{{json .State.Health}}' $(CONTAINER_NAME) | jq . 2>/dev/null \
		|| docker inspect --format='{{json .State.Health}}' $(CONTAINER_NAME)

.PHONY: test-nginx
test-nginx: ## Test nginx reverse proxy
	@curl -sI http://localhost:8080/health | grep "X-Reverse-Proxy: nginx"

.PHONY: help
help: ## show help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
