# PocketBase Docker

A minimal Docker image for [PocketBase](https://pocketbase.io/) with automatic superuser initialization from environment variables.

## Why This Image?

PocketBase does not provide an official Docker image yet. This project fills that gap with:

- **Minimal image** — based on Alpine Linux (~7MB overhead)
- **Automatic superuser creation** — credentials passed via `.env` file, no manual setup needed
- **Idempotent init** — safe to restart; superuser creation is silently skipped if already exists
- **Proper signal handling** — PocketBase runs as PID 1 via `exec`

## Quick Start

### 1. Create `docker-compose.yml` and `.env` file
`docker-compose.yml`
```yml
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


```bash
cp .env_format .env
```

Edit `.env` with your credentials:

```env
EMAIL=admin@example.com
PASSWORD=your-secure-password
PB_DATA_DIR=./pb_data
```

### 2. Run with Docker Compose

```bash
docker compose up -d
```

### 3. Or run with Docker directly

```bash
docker run -d \
  --name pocketbase \
  -p 127.0.0.1:8090:8090 \
  -v ./pb_data:/pb_data \
  -e EMAIL=admin@example.com \
  -e PASSWORD=your-secure-password \
  prateekrajgautam/pocketbase:latest
```

PocketBase will be available at `http://127.0.0.1:8090/_/`.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `EMAIL` | `admin@example.com` | Superuser email |
| `PASSWORD` | `admin` | Superuser password |
| `PB_DATA_DIR` | `./pb_data` | Host path for data volume |

## Build Locally

```bash
docker compose -f docker-compose-build.yml build
```

Or use the build script:

```bash
./build.sh
```

## License

MIT
