FROM docker.io/library/node:22-bookworm-slim
ARG VERSION=2.9.3
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /data
ADD https://github.com/linkwarden/linkwarden.git#v${VERSION} .
RUN yarn install --network-timeout 10000000 \
	&& npx playwright install --with-deps chromium \
	&& yarn cache clean \
	&& yarn prisma generate \
	&& yarn build

FROM gcr.io/distroless/nodejs22-debian12:nonroot
ENV NEXT_TELEMETRY_DISABLED=1
ENV DISABLE_PRESERVATION=true
WORKDIR /data
COPY --from=0 /data /data
COPY --chmod=644 ./init.js /init.js

EXPOSE 3000
CMD ["/init.js"]