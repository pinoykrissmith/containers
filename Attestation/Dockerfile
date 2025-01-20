FROM docker.io/library/eclipse-temurin:21-alpine as builder
RUN apk -U --no-cache upgrade && apk add --no-cache alpine-sdk swig git zopfli parallel yajl yajl-tools nginx \
	libxml2 moreutils unzip py3-virtualenv brotli python3 py3-pip nginx-mod-http-brotli nodejs npm bash libxml2-utils
WORKDIR /tmp/sqlite4java
ENV GITHUB_ACTIONS="true"
ENV PATH="/opt/venv/bin:$PATH"
ENV SKIP_REMOTE_PUBLISHING="1"

RUN git clone --depth=1 https://github.com/GrapheneOS/sqlite4java.git . \
	&& sed -i "s/amd64/$(uname -m)/g" Makefile && sed -i 's/-fcf-protection//g' Makefile \
	&& sed -i 's|^JAVA_HOME := .*|JAVA_HOME := /opt/java/openjdk|' Makefile && make

WORKDIR /app
RUN git clone --depth=1 https://github.com/GrapheneOS/AttestationServer.git . \
	&& sed -i 's/::1/0.0.0.0/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/8080/8000/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/app\.attestation\.auditor/app\.selfhosted\.auditor/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& sed -i 's/"attestation.app"/System.getenv("DOMAIN") != null ? System.getenv("DOMAIN") : "attestation.app"/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/"990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/System.getenv("CERTIFICATE") != null ? System.getenv("CERTIFICATE") : "990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& ./gradlew build && cp /tmp/sqlite4java/out/linux-$(uname -m)/*.so libs/sqlite4java-prebuilt \
	&& npm i && python3 -m venv /opt/venv && pip3 install --no-cache-dir -r requirements.txt && ./process-static

RUN $JAVA_HOME/bin/jlink \
	--add-modules java.base,java.compiler,java.desktop,java.logging,java.naming,java.security.sasl,java.sql,java.xml,jdk.httpserver,jdk.unsupported,jdk.crypto.ec,jdk.crypto.cryptoki,jdk.security.auth \
	--strip-debug --no-man-pages --no-header-files --compress=zip-6 --output /javaruntime

FROM docker.io/library/alpine:latest
ARG UID=200003
ARG GID=200003
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"

RUN addgroup -g $GID -S nginx || true \
	&& adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true \
	&& apk -U --no-cache upgrade \
	&& apk add --no-cache nginx nginx-mod-http-brotli brotli sqlite tzdata \
	&& rm -rf /var/cache/apk/*

RUN mkdir /var/cache/nginx \
	&& chown -R $UID:0 /var/cache/nginx && chmod -R g+w /var/cache/nginx \
	&& chown -R $UID:0 /etc/nginx && chmod -R g+w /etc/nginx \
	&& mkdir /app && chown -R $UID:0 /app && chmod -R g+w /app

RUN ln -sf /dev/stdout /var/log/nginx/access.log ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_filter_module.so /etc/nginx/modules/ngx_http_brotli_filter_module.so \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_static_module.so /etc/nginx/modules/ngx_http_brotli_static_module.so \
	&& mkdir /docker-entrypoint.d

COPY --chown=nginx:nginx --from=builder /app/nginx-tmp/mime.types /etc/nginx/
COPY --chown=nginx:nginx --from=builder /app/nginx-tmp/root_attestation.app.conf /etc/nginx/
COPY --chown=nginx:nginx --from=builder /app/nginx-tmp/snippets /etc/nginx/snippets
COPY --chown=nginx:nginx --from=builder /app/static-tmp /srv/attestation.app_a
COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.d /docker-entrypoint.d
COPY --from=ghcr.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=nginx:nginx --from=builder /app/build/libs/ /app
COPY --chown=nginx:nginx --from=builder /app/libs/sqlite4java-prebuilt/ /usr/lib
COPY --from=builder /javaruntime $JAVA_HOME
RUN printf '#!/bin/sh\n/opt/java/openjdk/bin/java -jar /app/attestation-server.jar &' > /docker-entrypoint.d/99-attestation.sh \
	&& chmod +x /docker-entrypoint.d/99-attestation.sh

EXPOSE 8080
STOPSIGNAL SIGQUIT
USER $UID
WORKDIR /data
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]