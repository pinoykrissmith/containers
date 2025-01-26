ARG VERSION=0.2.0
ARG POSTGRES=14
FROM docker.io/library/postgres:${POSTGRES}
ARG VERSION
ARG POSTGRES
RUN apt-get update && apt-get install -y curl
RUN curl -Lo /vectors.deb https://github.com/tensorchord/pgvecto.rs/releases/download/v${VERSION}/vectors-pg${POSTGRES}_${VERSION}_$(dpkg --print-architecture).deb

FROM docker.io/library/postgres:${POSTGRES}
COPY --from=0 /vectors.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && rm -rf /var/cache/apt/* && rm -f /usr/local/bin/gosu
RUN usermod -u 26 postgres
USER 26
CMD ["postgres", "-c", "shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors", "-c", "logging_collector=on", "-c", "max_wal_size=2GB", "-c", "shared_buffers=512MB", "-c", "wal_compression=on"]