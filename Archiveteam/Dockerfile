FROM atdr.meo.ws/archiveteam/warrior-dockerfile:latest
ARG UID=200014
USER root
RUN apt-get update \
	&& apt-get upgrade -y && apt-get dist-upgrade -y \
	&& rm -rf /var/cache/apt/* /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade --upgrade-strategy eager -r /tmp/requirements.txt
RUN --network=none usermod -u ${UID} warrior && groupmod -g ${UID} warrior \
	&& find / -path /proc -prune -o -user 1000 -exec chown warrior {} + && find / -path /proc -prune -o -group 1000 -exec chgrp warrior {} +
RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /usr/bin/su
USER warrior