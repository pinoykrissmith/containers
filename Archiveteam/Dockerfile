FROM atdr.meo.ws/archiveteam/warrior-dockerfile:latest
USER root
RUN apt-get update \
	&& apt-get upgrade -y \
	&& rm -rf /var/cache/apt/*
USER 1000