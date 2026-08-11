# PocketBase Docker

Minimal Docker image for [PocketBase](https://pocketbase.io/) with automatic superuser initialization.

## Why?

PocketBase has no official Docker image yet. This provides a minimal, ready-to-use container with auto-configured admin credentials.

## Quick Start

```bash
docker run -d \
  --name pocketbase \
  -p 127.0.0.1:8090:8090 \
  -v ./pb_data:/pb_data \
  -e EMAIL=admin@example.com \
  -e PASSWORD=your-secure-password \
  prateekrajgautam/pocketbase:latest
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `EMAIL` | `admin@example.com` | Superuser email |
| `PASSWORD` | `admin` | Superuser password |

## Docker Compose

`docker-compose.yml` file
```yaml
services:
  pocketbase:
    image: prateekrajgautam/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    ports:
      - 127.0.0.1:8090:8090
    volumes:
      - ${PB_DATA_DIR:-./pb_data}:/pb_data
    environment:
      - EMAIL=${EMAIL:-admin@example.com}
      - PASSWORD=${PASSWORD:-admin}

```

`.env` file

```ini
EMAIL=admin@example.com
PASSWORD=admin
PB_DATA_DIR=./pb_data
```

## How It Works

On every container start:
1. Creates superuser from `EMAIL`/`PASSWORD` env vars (silently skipped if already exists)
2. Starts PocketBase server on port 8090

## Links

- [GitHub](https://github.com/prateekrajgautam/pocketbase-docker)
- [PocketBase](https://pocketbase.io)
