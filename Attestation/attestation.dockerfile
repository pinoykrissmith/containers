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
	&& sed -i 's/app\.attestation\.auditor/app\.selfhosted\.auditor/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& sed -i 's/"attestation.app"/System.getenv("DOMAIN") != null ? System.getenv("DOMAIN") : "attestation.app"/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/"990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/System.getenv("CERTIFICATE") != null ? System.getenv("CERTIFICATE") : "990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& npm i && python3 -m venv /opt/venv && pip3 install -r requirements.txt && ./process-static

FROM docker.io/library/alpine:latest
ARG UID=101
ARG GID=101

RUN addgroup -g $GID -S nginx || true \
	&& adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true \
	&& apk add --no-cache nginx nginx-mod-http-brotli brotli \
	&& rm -rf /var/cache/apk/*

RUN sed -i 's,listen       80;,listen       8080;,' /etc/nginx/conf.d/default.conf \
	&& chown -R $UID:0 /var/cache/nginx \
	&& chmod -R g+w /var/cache/nginx \
	&& chown -R $UID:0 /etc/nginx \
	&& chmod -R g+w /etc/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& mkdir /docker-entrypoint.d

COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/mime.types /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/root_attestation.app.conf /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/snippets /etc/nginx/snippets
COPY --from=0 --chown=nginx:nginx /app/static-tmp /srv/attestation.app_a
COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:mainline-alpine-slim /docker-entrypoint.sh /
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:mainline-alpine-slim /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:mainline-alpine-slim /docker-entrypoint.d/15-local-resolvers.envsh /docker-entrypoint.d
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:mainline-alpine-slim /docker-entrypoint.d/20-envsubst-on-templates.sh /docker-entrypoint.d
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:mainline-alpine-slim /docker-entrypoint.d/30-tune-worker-processes.sh /docker-entrypoint.d

EXPOSE 8080
STOPSIGNAL SIGQUIT
USER $UID
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]