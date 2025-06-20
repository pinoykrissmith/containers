ARG PG_MAJOR=14
FROM docker.io/library/postgres:${PG_MAJOR}
ARG VERSION=0.4.3
ARG UID=200012

RUN apt-get update && apt-get install -y ca-certificates postgresql-$PG_MAJOR-pgvector wget \
	&& wget -nv -O /tmp/vchord.deb https://github.com/tensorchord/VectorChord/releases/download/$VERSION/postgresql-${PG_MAJOR%.*}-vchord_${VERSION#"v"}-1_$(dpkg --print-architecture).deb \
	&& apt-get install -y /tmp/vchord.deb && apt-get purge -y ca-certificates wget && apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/vchord.deb /usr/local/bin/gosu

RUN --network=none usermod -u ${UID} postgres && groupmod -g ${UID} postgres \
	&& find / -path /proc -prune -o -user 999 -exec chown postgres {} + && find / -path /proc -prune -o -group 999 -exec chgrp postgres {} +

RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /usr/bin/su

ADD --chmod=644 --chown=${UID}:${UID} https://github.com/immich-app/base-images/raw/480dd76db004ac33d4cdb4504e675e79b0b3242e/postgres/postgresql.ssd.conf /etc/postgresql/postgresql.ssd.conf
ADD --chmod=644 --chown=${UID}:${UID} https://github.com/immich-app/base-images/raw/480dd76db004ac33d4cdb4504e675e79b0b3242e/postgres/postgresql.hdd.conf /etc/postgresql/postgresql.hdd.conf

USER postgres
HEALTHCHECK --interval=5m --start-interval=30s --start-period=5m CMD pg_isready --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" || exit 1; Chksum="$(psql --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')"; echo "checksum failure count is $Chksum"; [ "$Chksum" = '0' ] || exit 1
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.ssd.conf"]