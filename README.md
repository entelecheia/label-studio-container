# label-studio-container

Docker container setup for Label Studio, an open source data labeling tool.

## Overview

This repository contains Docker Compose configuration for running Label Studio in a containerized environment. Label Studio is a versatile data labeling tool that supports various data types including text, images, audio, video, and time series data.

## Prerequisites

- Docker Engine
- Docker Compose

## Directory Structure

```
.
├── .env                    # Environment variables
├── docker-compose.yml      # Docker compose configuration
├── workspace/             # Workspace directory
│   ├── data              # Data storage
│   ├── export            # Export directory
│   └── upload            # Upload directory
└── README.md             # This file
```

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/entelecheialabel-studio-container.git
   cd label-studio-container
   ```

2. Create required directories:
   ```bash
   mkdir -p workspace/{data,export,upload}
   ```

3. Start Label Studio:
   ```bash
   docker compose up -d
   ```

4. Access Label Studio at http://localhost:8080

## Environment Variables

The following environment variables can be configured in the `.env` file:

- `LABEL_STUDIO_BASE_DATA_DIR`: Base directory for data storage
- `POSTGRES_USER`: PostgreSQL database user
- `POSTGRES_PASSWORD`: PostgreSQL database password
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_PORT`: PostgreSQL port (default: 5432)

## License

This project is licensed under the MIT License. Label Studio itself is licensed under the Apache License 2.0.