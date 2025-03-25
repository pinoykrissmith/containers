ARG VERSION=0.2.0
ARG POSTGRES=14
FROM docker.io/library/postgres:${POSTGRES}
ARG VERSION
RUN apt-get update && apt-get install -y curl
RUN curl -Lo /vectors.deb https://github.com/tensorchord/pgvecto.rs/releases/download/v${VERSION}/vectors-pg${PG_MAJOR}_${VERSION}_$(dpkg --print-architecture).deb
RUN mkdir /install && dpkg-deb -xv /vectors.deb /install

FROM docker.io/library/postgres:${POSTGRES}
ARG UID=200012
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
	&& rm -rf /var/cache/apt/* /var/lib/apt/lists/* /usr/local/bin/gosu
COPY --from=0 /install/usr/lib/postgresql/${PG_MAJOR}/lib/vectors.so /usr/lib/postgresql/${PG_MAJOR}/lib/vectors.so
COPY --from=0 /install/usr/share/postgresql/${PG_MAJOR}/extension /usr/share/postgresql/${PG_MAJOR}/extension
RUN --network=none usermod -u ${UID} postgres && groupmod -g ${UID} postgres \
	&& find / -path /proc -prune -o -user 999 -exec chown postgres {} + && find / -path /proc -prune -o -group 999 -exec chgrp postgres {} +
RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /usr/bin/su
USER ${UID}
CMD ["postgres", "-c", "shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors", "-c", "logging_collector=on", "-c", "max_wal_size=2GB", "-c", "shared_buffers=512MB", "-c", "wal_compression=on"]