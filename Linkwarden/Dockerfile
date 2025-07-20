ARG VERSION=2.11.5

FROM ghcr.io/linkwarden/linkwarden:v${VERSION}
ARG UID=200015
ENV NEXT_TELEMETRY_DISABLED=1 \
	DISABLE_PRESERVATION=true
RUN apt-get update \
	&& apt-get upgrade -y && apt-get dist-upgrade -y \
	&& rm -rf /var/cache/apt/* /var/lib/apt/lists/*
RUN --network=none usermod -u ${UID} node && groupmod -g ${UID} node \
	&& find / -path /proc -prune -o -user 1000 -exec chown node {} + && find / -path /proc -prune -o -group 1000 -exec chgrp node {} +
RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /bin/su
USER node