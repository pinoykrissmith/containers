FROM atdr.meo.ws/archiveteam/warrior-dockerfile:latest
ARG UID=200014
USER root
RUN apt-get update \
	&& apt-get upgrade -y && apt-get dist-upgrade -y \
	&& rm -rf /var/cache/apt/*
RUN pip install --no-cache-dir --upgrade --upgrade-strategy eager -r /tmp/requirements.txt
RUN --network=none usermod -u ${UID} warrior && groupmod -g ${UID} warrior \
	&& find / -path /proc -prune -o -user 1000 -exec chown warrior {} + && find / -path /proc -prune -o -group 1000 -exec chgrp warrior {} +
ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN --network=none /tmp/removesuid.sh || true && rm /tmp/removesuid.sh
USER ${UID}
ENTRYPOINT []
CMD [ "python", "start.py" ]