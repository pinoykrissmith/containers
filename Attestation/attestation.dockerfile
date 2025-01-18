FROM docker.io/library/eclipse-temurin:21-noble

WORKDIR /tmp
ADD https://deb.nodesource.com/setup_23.x ./nodesource_setup.sh
RUN chmod +x /tmp/nodesource_setup.sh \
	&& /tmp/nodesource_setup.sh

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y zopfli parallel yajl-tools nginx python3 python3-pip nodejs \
	libxml2 moreutils unzip python3-venv libxml2-utils brotli git \
	libnginx-mod-http-brotli-filter libnginx-mod-http-brotli-static \
	&& rm -rf /var/cache/apt/*

ENV GITHUB_ACTIONS="true"
ENV PATH="/opt/venv/bin:$PATH"
ENV SKIP_REMOTE_PUBLISHING="1"

WORKDIR /app
RUN git clone --depth=1 https://github.com/GrapheneOS/AttestationServer . \
	&& sed -i 's/::1/0.0.0.0/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/"attestation.app"/System.getenv("DOMAIN") != null ? System.getenv("DOMAIN") : "attestation.app"/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& npm i && python3 -m venv /opt/venv && pip3 install -r requirements.txt && ./process-static

FROM ghcr.io/nginxinc/nginx-unprivileged:stable-alpine
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/mime.types /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/root_attestation.app.conf /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/snippets /etc/nginx/snippets
COPY --from=0 --chown=nginx:nginx /app/static-tmp /srv/attestation.app_a
COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf