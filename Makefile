# Makefile for Label Studio Container

# Variables
SHELL := /bin/bash
WORKSPACE_DIR := workspace
DATA_DIR := $(WORKSPACE_DIR)/mydata
DEPLOY_DIR := $(WORKSPACE_DIR)/deploy
BACKUP_DIR := backups
COMPOSE_FILE := docker-compose.yaml
ENV_FILE := .env
ENV_EXAMPLE := .env.example

# Docker Compose command with default options
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

# Default target
.PHONY: all
all: help

# Help target
.PHONY: help
help:
	@echo "Label Studio Container Management"
	@echo ""
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  init          - Initialize directory structure and environment file"
	@echo "  setup         - Complete setup (init + build)"
	@echo "  build         - Build or rebuild services"
	@echo "  start         - Start all services"
	@echo "  stop          - Stop all services"
	@echo "  restart       - Restart all services"
	@echo "  status        - Show status of services"
	@echo "  logs          - View logs from all services"
	@echo "  backup        - Create backup of database and volumes"
	@echo "  clean         - Remove all containers and volumes"
	@echo "  update        - Update all services to latest version"
	@echo ""
	@echo "Service-specific logs:"
	@echo "  logs-app      - View Label Studio application logs"
	@echo "  logs-nginx    - View Nginx logs"
	@echo "  logs-db       - View PostgreSQL logs"
	@echo "  logs-redis    - View Redis logs"

# Initialize directories and environment file
.PHONY: init
init:
	@echo "Creating directory structure..."
	mkdir -p $(DATA_DIR)/{data,export,upload,postgres-data}
	mkdir -p $(DEPLOY_DIR)/{nginx,pgsql}/certs
	@if [ ! -f "$(ENV_FILE)" ] && [ -f "$(ENV_EXAMPLE)" ]; then \
		echo "Creating $(ENV_FILE) from example..."; \
		cp $(ENV_EXAMPLE) $(ENV_FILE); \
	fi
	@echo "Initialization complete. Please edit $(ENV_FILE) with your settings."

# Build services
.PHONY: build
build:
	$(DOCKER_COMPOSE) build

# Start services
.PHONY: start
start:
	$(DOCKER_COMPOSE) up -d

# Stop services
.PHONY: stop
stop:
	$(DOCKER_COMPOSE) down

# Restart services
.PHONY: restart
restart: stop start

# Show status
.PHONY: status
status:
	$(DOCKER_COMPOSE) ps

# View all logs
.PHONY: logs
logs:
	$(DOCKER_COMPOSE) logs -f

# Service-specific logs
.PHONY: logs-app logs-nginx logs-db logs-redis
logs-app:
	$(DOCKER_COMPOSE) logs -f app

logs-nginx:
	$(DOCKER_COMPOSE) logs -f nginx

logs-db:
	$(DOCKER_COMPOSE) logs -f db

logs-redis:
	$(DOCKER_COMPOSE) logs -f redis

# Create backup
.PHONY: backup
backup:
	@echo "Creating backup directory..."
	@mkdir -p $(BACKUP_DIR)
	@echo "Backing up database..."
	@$(DOCKER_COMPOSE) exec db pg_dump -U $$(grep POSTGRES_USER $(ENV_FILE) | cut -d '=' -f2) \
		$$(grep POSTGRES_DB $(ENV_FILE) | cut -d '=' -f2) > $(BACKUP_DIR)/db_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backing up volumes..."
	@tar -czf $(BACKUP_DIR)/data_backup_$$(date +%Y%m%d_%H%M%S).tar.gz $(DATA_DIR)
	@echo "Backup complete. Files saved in $(BACKUP_DIR)/"

# Clean everything
.PHONY: clean
clean:
	@echo "WARNING: This will remove all containers, volumes, and data."
	@read -p "Are you sure? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		$(DOCKER_COMPOSE) down -v; \
		echo "Cleaning up data directories..."; \
		rm -rf $(DATA_DIR)/*; \
		echo "Clean complete."; \
	fi

# Complete setup
.PHONY: setup
setup: init build start
	@echo "Setup complete. Label Studio is now available at http://localhost:8080"

# Update services
.PHONY: update
update:
	$(DOCKER_COMPOSE) pull
	@echo "Services updated. Run 'make restart' to apply changes."

# Set proper permissions
.PHONY: fix-permissions
fix-permissions:
	sudo chown -R 1001:1001 $(DATA_DIR)
	@echo "Permissions fixed for data directory."
