.DEFAULT_GOAL := help

.PHONY: build
build: ## build docker image
	docker build -t junior-devops-app .

.PHONY: up
up: ## up containers
	docker compose up -d

.PHONY: down
down: ## down containers
	docker compose down

.PHONY: logs
logs: ## see docker logs
	docker compose logs -f

.PHONY: backup
backup: ## do backups
	./scripts/backup.sh

.PHONY: help
help: ## show help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
