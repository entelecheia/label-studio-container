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

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum (8GB recommended)
- 10GB disk space minimum

## Directory Structure

```
.
├── .env                    # Environment variables configuration
├── docker-compose.yaml     # Docker compose configuration
├── deploy/                 # Deployment configurations
│   ├── nginx/             # Nginx configurations and certificates
│   │   └── certs/         # SSL certificates
│   └── pgsql/             # PostgreSQL configurations
│       └── certs/         # PostgreSQL SSL certificates
├── mydata/                # Label Studio data directory
│   ├── data              # Application data
│   ├── export            # Export directory
│   └── upload            # Upload directory
└── README.md             # This documentation
```

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/entelecheia/label-studio-container.git
   cd label-studio-container
   ```

2. Create required directories:
   ```bash
   mkdir -p mydata/{data,export,upload}
   mkdir -p deploy/{nginx,pgsql}/certs
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env file with your preferred settings
   ```

4. Start Label Studio:
   ```bash
   docker compose up -d
   ```

5. Access Label Studio at http://localhost:8080

## Security Configuration

Before deploying to production, make sure to:

1. Change all default passwords in `.env`:
   - `LABEL_STUDIO_PASSWORD`
   - `POSTGRES_PASSWORD`
   - `REDIS_PASSWORD`
   - `LABEL_STUDIO_SECRET_KEY`

2. Enable SSL:
   - Place SSL certificates in `deploy/nginx/certs/`
   - Uncomment SSL configuration in `docker-compose.yaml`
   - Update `LABEL_STUDIO_PROTOCOL` to `https` in `.env`

## Environment Variables

See the `.env` file for all available configuration options. Key variables include:

- `LABEL_STUDIO_USERNAME`: Admin username
- `LABEL_STUDIO_PASSWORD`: Admin password
- `LABEL_STUDIO_SECRET_KEY`: Django secret key
- `POSTGRES_*`: PostgreSQL configuration
- `REDIS_*`: Redis configuration

## Maintenance

### Backup

1. Database backup:
   ```bash
   docker compose exec db pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup.sql
   ```

2. Volume backup:
   ```bash
   tar -czf label-studio-data.tar.gz mydata/
   ```

### Logs

View logs for specific services:
```bash
docker compose logs -f app    # Label Studio logs
docker compose logs -f nginx  # Nginx logs
docker compose logs -f db     # PostgreSQL logs
docker compose logs -f redis  # Redis logs
```

## Troubleshooting

1. If services fail to start, check logs:
   ```bash
   docker compose logs -f
   ```

2. If database connection fails:
   - Verify PostgreSQL credentials in `.env`
   - Check if PostgreSQL container is healthy:
     ```bash
     docker compose ps db
     ```

3. For permission issues:
   - Ensure proper ownership of data directories:
     ```bash
     sudo chown -R 1001:1001 mydata/
     ```

## License

This project is licensed under the MIT License. Label Studio itself is licensed under the Apache License 2.0.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.