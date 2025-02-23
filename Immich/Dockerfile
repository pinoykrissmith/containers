ARG VERSION=0.2.0
ARG POSTGRES=14
FROM docker.io/library/postgres:${POSTGRES}
ARG VERSION
ARG POSTGRES
RUN apt-get update && apt-get install -y curl
RUN curl -Lo /vectors.deb https://github.com/tensorchord/pgvecto.rs/releases/download/v${VERSION}/vectors-pg${POSTGRES}_${VERSION}_$(dpkg --print-architecture).deb

FROM docker.io/library/postgres:${POSTGRES}
ARG UID=200012
COPY --from=0 /vectors.deb /tmp/vectors.deb
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
	&& apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && rm -rf /var/cache/apt/* && rm -f /usr/local/bin/gosu
RUN --network=none usermod -u ${UID} postgres && groupmod -g ${UID} postgres \
	&& find / -path /proc -prune -o -user 999 -exec chown postgres {} + && find / -path /proc -prune -o -group 999 -exec chgrp postgres {} +
ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN /tmp/removesuid.sh || true && rm /tmp/removesuid.sh

USER ${UID}
CMD ["postgres", "-c", "shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors", "-c", "logging_collector=on", "-c", "max_wal_size=2GB", "-c", "shared_buffers=512MB", "-c", "wal_compression=on"]