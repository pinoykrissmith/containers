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
	&& npm i && python3 -m venv /opt/venv && pip3 install --no-cache-dir -r requirements.txt && ./process-static

FROM docker.io/library/alpine:latest
ARG UID=101
ARG GID=101

RUN addgroup -g $GID -S nginx || true \
	&& adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true \
	&& apk add --no-cache nginx nginx-mod-http-brotli brotli \
	&& rm -rf /var/cache/apk/*

RUN mkdir /var/cache/nginx \
	&& chown -R $UID:0 /var/cache/nginx \
	&& chmod -R g+w /var/cache/nginx \
	&& chown -R $UID:0 /etc/nginx \
	&& chmod -R g+w /etc/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_filter_module.so /etc/nginx/modules/ngx_http_brotli_filter_module.so \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_static_module.so /etc/nginx/modules/ngx_http_brotli_static_module.so \
	&& mkdir /docker-entrypoint.d

COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/mime.types /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/root_attestation.app.conf /etc/nginx/
COPY --from=0 --chown=nginx:nginx /app/nginx-tmp/snippets /etc/nginx/snippets
COPY --from=0 --chown=nginx:nginx /app/static-tmp /srv/attestation.app_a
COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.d /docker-entrypoint.d
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 8080
STOPSIGNAL SIGQUIT
USER $UID
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]