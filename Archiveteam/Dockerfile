FROM atdr.meo.ws/archiveteam/warrior-dockerfile:latest
ARG UID=200014
USER root
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get dist-upgrade -y \
	&& rm -rf /var/cache/apt/*
RUN --network=none usermod -u ${UID} warrior && groupmod -g ${UID} warrior \
	&& find / -path /proc -prune -user 1000 -exec chown -h warrior {} \; && find / -path /proc -prune -group 1000 -exec chgrp -h warrior {} \;
ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN /tmp/removesuid.sh || true && rm /tmp/removesuid.sh
USER ${UID}