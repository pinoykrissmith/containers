ARG VERSION=2.16.1
FROM ghcr.io/linkwarden/linkwarden:v${VERSION} AS build
FROM docker.io/library/node:22-trixie-slim
WORKDIR /data
ARG UID=200015
ENV NODE_ENV=production \
	PRISMA_HIDE_UPDATE_MESSAGE=1 \
	COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
	PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
	DEBIAN_FRONTEND=noninteractive \
	NEXT_TELEMETRY_DISABLED=1

COPY --from=build /usr/local/bin/monolith /usr/local/bin/monolith
COPY --from=build /data/ /data/

RUN export PATH=/data/node_modules/.bin:$PATH \
	&& apt-get update \
	&& apt-get install -yqq --no-install-recommends curl ca-certificates openssl procps \
	&& corepack enable && corepack install \
	&& playwright install --with-deps chromium-headless-shell \
	&& npx prisma generate --schema packages/prisma/schema.prisma \
	&& chmod 755 /root && ln -sf /root/.cache /home/node \
	&& mkdir -p apps/web/.next/cache && chmod 777 apps/web/.next/cache \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* /root/.npm

HEALTHCHECK --interval=30s \
	--timeout=5s \
	--start-period=10s \
	--retries=3 \
	CMD [ "/usr/bin/curl", "--silent", "--fail", "http://127.0.0.1:3000/" ]

RUN --network=none usermod -u ${UID} node && groupmod -g ${UID} node \
	&& find / -path /proc -prune -o -user 1000 -exec chown node {} + && find / -path /proc -prune -o -group 1000 -exec chgrp node {} +
RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /bin/su

EXPOSE 3000
USER node

CMD ["sh", "-c", "export PATH=/data/node_modules/.bin:$PATH && prisma migrate deploy --schema=/data/packages/prisma/schema.prisma && exec concurrently -k -n web,worker \"cd /data/apps/web && exec next start\" \"cd /data/apps/worker && exec tsx worker.ts\""]