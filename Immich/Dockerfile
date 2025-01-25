FROM docker.io/library/debian:bookworm-slim
RUN apt-get update && apt-get install -y curl
RUN curl -Lo /vectors.deb https://github.com/tensorchord/pgvecto.rs/releases/download/v0.2.0/vectors-pg14_0.2.0_$(dpkg --print-architecture).deb

FROM docker.io/library/postgres:14-bookworm
COPY --from=0 /vectors.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && rm -rf /var/cache/apt/* && rm -f /usr/local/bin/gosu
RUN usermod -u 26 postgres
USER 26
CMD ["postgres", "-c" ,"shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors"]