FROM docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0-rootless

USER root
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/cache/apt/*
RUN rm -f /usr/local/bin/gosu
USER 26