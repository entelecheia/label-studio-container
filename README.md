# Label Studio Container

Docker container setup for Label Studio, an open source data labeling tool.

## Overview

This repository contains a production-ready Docker Compose configuration for running Label Studio in a containerized environment. Label Studio is a versatile data labeling tool that supports various data types including text, images, audio, video, and time series data.

## Features

- Production-ready Docker Compose setup
- Secure configuration with environment variables
- PostgreSQL database for data persistence
- Redis for caching and session management
- Nginx reverse proxy
- Health checks for all services
- Automatic container restart
- Volume management for data persistence
- Network isolation
- Makefile for easy management

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- GNU Make
- 4GB RAM minimum (8GB recommended)
- 10GB disk space minimum

## Directory Structure

```
.
├── .env                    # Environment variables configuration
├── docker-compose.yaml     # Docker compose configuration
├── Makefile               # Make commands for easy management
├── workspace/             # Workspace directory
│   ├── deploy/            # Deployment configurations
│   │   ├── nginx/        # Nginx configurations and certificates
│   │   │   └── certs/    # SSL certificates
│   │   └── pgsql/        # PostgreSQL configurations
│   │       └── certs/    # PostgreSQL SSL certificates
│   └── mydata/           # Label Studio data directory
│       ├── data          # Application data
│       ├── export        # Export directory
│       └── upload        # Upload directory
└── README.md             # This documentation
```

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/entelecheia/label-studio-container.git
   cd label-studio-container
   ```

2. Set up the environment:
   ```bash
   make setup
   ```
   This will:
   - Create necessary directories
   - Copy the example environment file
   - Build and start the services

3. Access Label Studio at http://localhost:8080

## Using the Makefile

The project includes a Makefile for easy management of common tasks:

```bash
# Complete setup
make setup              # Initialize, build, and start services

# Service management
make start             # Start all services
make stop              # Stop all services
make restart           # Restart all services
make status            # Show service status
make update            # Update services to latest version

# Logs
make logs              # View all logs
make logs-app          # View Label Studio logs
make logs-nginx        # View Nginx logs
make logs-db           # View PostgreSQL logs
make logs-redis        # View Redis logs

# Maintenance
make backup            # Create backup of database and volumes
make clean             # Remove all containers and volumes
make fix-permissions   # Fix data directory permissions
```

For a complete list of available commands, run:
```bash
make help
```

## Security Configuration

Before deploying to production, make sure to:

1. Change all default passwords in `.env`:
   - `LABEL_STUDIO_PASSWORD`
   - `POSTGRES_PASSWORD`
   - `REDIS_PASSWORD`
   - `LABEL_STUDIO_SECRET_KEY`

2. Enable SSL:
   - Place SSL certificates in `workspace/deploy/nginx/certs/`
   - Uncomment SSL configuration in `docker-compose.yaml`
   - Update `LABEL_STUDIO_PROTOCOL` to `https` in `.env`

## Environment Variables

See the `.env` file for all available configuration options. Key variables include:

### User Authentication
- `LABEL_STUDIO_USERNAME`: Admin username
- `LABEL_STUDIO_PASSWORD`: Admin password
- `LABEL_STUDIO_SECRET_KEY`: Django secret key

### Port Configuration
- `NGINX_HTTP_PORT`: HTTP port for web interface (default: 8080)
- `NGINX_HTTPS_PORT`: HTTPS port for web interface (default: 8081)
- `APP_PORT`: Internal application port (default: 8000)
- `POSTGRES_PORT`: PostgreSQL database port (default: 5432)
- `REDIS_PORT`: Redis port (default: 6379)

### Database Configuration
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_HOST`: PostgreSQL host

### Cache Configuration
- `REDIS_HOST`: Redis host
- `REDIS_PASSWORD`: Redis password

## Maintenance

### Backup

Use the make command to create backups:
```bash
make backup
```

This will:
1. Create a database dump
2. Create a tar archive of the data directory
3. Store backups in the `backups` directory

### Logs

View logs using make commands:
```bash
make logs          # All services
make logs-app      # Label Studio logs
make logs-nginx    # Nginx logs
make logs-db       # PostgreSQL logs
make logs-redis    # Redis logs
```

## Troubleshooting

1. If services fail to start:
   ```bash
   make logs
   ```

2. If database connection fails:
   - Verify PostgreSQL credentials in `.env`
   - Check if PostgreSQL container is healthy:
     ```bash
     make status
     ```

3. For permission issues:
   ```bash
   make fix-permissions
   ```

## License

This project is licensed under the MIT License. Label Studio itself is licensed under the Apache License 2.0.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.