# ─────────────────────────────────────────────
# Inception Project Makefile (Refactored)
# ─────────────────────────────────────────────

DC              = cd srcs && docker compose
DATA_DIR        = /home/${USER}/data
WORDPRESS_DIR   = $(DATA_DIR)/wordpress
MARIADB_DIR     = $(DATA_DIR)/mariadb
DOMAIN          = ${USER}.42.fr

# ─────────────────────────────────────────────
# Main Targets
# ─────────────────────────────────────────────

all: setup build up

setup:
	@echo "=== Preparing environment ==="
	@sudo mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR)
	@sudo chmod 777 $(WORDPRESS_DIR) $(MARIADB_DIR)
	@grep -q "$(DOMAIN)" /etc/hosts || echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts >/dev/null

build:
	@echo "=== Building images ==="
	@$(DC) build --no-cache

up:
	@echo "=== Starting containers ==="
	mkdir -p /home/zed/data/mariadb
	mkdir -p /home/zed/data/wordpress
	sudo chown -R $(USER):$(USER) /home/zed/data
	@$(DC) up -d

down:
	@$(DC) down

restart: down up

# ─────────────────────────────────────────────
# Maintenance
# ─────────────────────────────────────────────

clean: down
	@echo "=== Pruning Docker system ==="
	@docker system prune -af --volumes

fclean: clean
	@echo "=== Removing data and host entry ==="
	@sudo rm -rf $(DATA_DIR)
	@sudo sed -i "/$(DOMAIN)/d" /etc/hosts

re: fclean all

status:
	@$(DC) ps
	@docker images
	@docker volume ls
	@docker network ls

logs:
	@$(DC) logs -f

info:
	@docker ps
	@docker inspect -f '{{.Name}} -> {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$(docker ps -q)

.PHONY: all setup build up down restart clean fclean re status logs info
