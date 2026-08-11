ARG PB_VERSION=0.39.9

# ------------------------------------------------------------
# Stage 1: Download PocketBase binary
# ------------------------------------------------------------
FROM alpine AS downloader

ARG PB_VERSION
#ARG TARGETARCH

RUN apk add --no-cache ca-certificates wget unzip

#RUN set -eux; \
#    case "${TARGETARCH}" in \
 #       amd64) PB_ARCH="amd64" ;; \
  #      arm64) PB_ARCH="arm64" ;; \
   #     *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    #esac; \
RUN wget -q \
      "https://github.com/pocketbase/pocketbase/releases/download/v0.39.10/pocketbase_0.39.10_linux_amd64.zip" \
      -O /tmp/pocketbase.zip; \
    unzip -q /tmp/pocketbase.zip -d /tmp/pocketbase; \
    chmod +x /tmp/pocketbase/pocketbase


# ------------------------------------------------------------
# Stage 2: Minimal runtime image
# ------------------------------------------------------------
FROM alpine:3.20

ARG PB_VERSION

LABEL \
    org.opencontainers.image.title="PocketBase" \
    org.opencontainers.image.description="Minimal PocketBase container" \
    org.opencontainers.image.version="${PB_VERSION}" \
    org.opencontainers.image.source="https://github.com/pocketbase/pocketbase"

COPY --from=downloader /tmp/pocketbase/pocketbase /pocketbase
RUN chmod +x /pocketbase

VOLUME ["/pb_data"]
EXPOSE 8090

ENTRYPOINT ["/bin/sh", "-c", "\
  pocketbase superuser create \"${EMAIL:-admin@example.com}\" \"${PASSWORD:-admin}\" --dir=/pb_data 2>/dev/null || true;\
  exec pocketbase serve --http=0.0.0.0:8090 --dir=/pb_data"]