FROM docker.io/library/eclipse-temurin:21-alpine
ENV GITHUB_ACTIONS="true" \
	PATH="/opt/venv/bin:$PATH" \
	SKIP_REMOTE_PUBLISHING="1"
RUN apk -U --no-cache upgrade && apk add --no-cache alpine-sdk swig git zopfli parallel yajl yajl-tools nginx \
	libxml2 moreutils unzip py3-virtualenv brotli python3 py3-pip nginx-mod-http-brotli nodejs npm bash libxml2-utils

WORKDIR /tmp/sqlite4java
ADD https://github.com/GrapheneOS/sqlite4java.git#main .
RUN sed -i "s/amd64/$(uname -m)/g" Makefile && sed -i 's/-fcf-protection//g' Makefile \
	&& sed -i 's|^JAVA_HOME := .*|JAVA_HOME := /opt/java/openjdk|' Makefile && make

WORKDIR /app
ADD https://github.com/GrapheneOS/AttestationServer.git#main .
RUN sed -i 's/::1/0.0.0.0/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/8080/8000/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/app\.attestation\.auditor/app\.selfhosted\.auditor/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& sed -i 's/"attestation.app"/System.getenv("DOMAIN") != null ? System.getenv("DOMAIN") : "attestation.app"/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/"990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/System.getenv("CERTIFICATE") != null ? System.getenv("CERTIFICATE") : "990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/g' src/main/java/app/attestation/server/AttestationProtocol.java
RUN ./gradlew build && rm -f build/libs/*.so
RUN npm i && python3 -m venv /opt/venv && pip3 install --no-cache-dir -r requirements.txt && ./process-static

RUN $JAVA_HOME/bin/jlink --add-modules java.base,java.compiler,java.desktop,java.logging,java.naming,java.security.sasl,java.sql,java.xml,jdk.httpserver,jdk.unsupported,jdk.crypto.ec,jdk.crypto.cryptoki,jdk.security.auth \
	--strip-debug --no-man-pages --no-header-files --compress=zip-6 --output /javaruntime

FROM docker.io/library/alpine:latest
ARG UID=200003
ENV JAVA_HOME=/opt/java/openjdk \
	PATH="/opt/java/openjdk/bin:$PATH"
RUN --network=none addgroup -g $UID -S nginx || true && adduser -S -D -H -u $UID -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true
RUN apk add --no-cache nginx nginx-mod-http-brotli brotli java-common java-cacerts sqlite tzdata

RUN --network=none mkdir /var/cache/nginx \
	&& chown -R $UID:0 /var/cache/nginx && chmod -R g+w /var/cache/nginx \
	&& chown -R $UID:0 /etc/nginx && chmod -R g+w /etc/nginx

RUN --network=none ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_filter_module.so /etc/nginx/modules/ngx_http_brotli_filter_module.so \
	&& ln -s /usr/lib/nginx/modules/ngx_http_brotli_static_module.so /etc/nginx/modules/ngx_http_brotli_static_module.so

COPY --from=0 /app/nginx-tmp/mime.types /etc/nginx/
COPY --from=0 /app/nginx-tmp/root_attestation.app.conf /etc/nginx/
COPY --from=0 /app/nginx-tmp/snippets /etc/nginx/snippets
COPY --from=0 /app/static-tmp /srv/attestation.app_a
COPY --chmod=644 ./nginx.conf /etc/nginx/nginx.conf
COPY --from=docker.io/nginxinc/nginx-unprivileged:stable-alpine-slim /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=docker.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.d /docker-entrypoint.d
COPY --from=docker.io/nginxinc/nginx-unprivileged:stable-alpine-slim /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=0 /app/build/libs /app
COPY --from=0 /tmp/sqlite4java/out/linux-*/libsqlite4java-*.so /usr/lib
COPY --from=0 /javaruntime $JAVA_HOME
RUN --network=none printf '#!/bin/sh\n/opt/java/openjdk/bin/java -jar /app/attestation-server.jar &' > /docker-entrypoint.d/99-attestation.sh \
	&& chmod +x /docker-entrypoint.d/99-attestation.sh

EXPOSE 8080
STOPSIGNAL SIGQUIT
USER nginx
WORKDIR /data
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]