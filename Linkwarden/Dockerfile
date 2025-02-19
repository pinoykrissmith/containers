ARG VERSION=2.9.3

FROM docker.io/library/rust:1.80-bookworm
RUN cargo install --locked monolith

FROM docker.io/library/node:18-bookworm-slim
ARG VERSION
WORKDIR /data
ADD https://github.com/linkwarden/linkwarden.git#v${VERSION} .
RUN yarn install --network-timeout 10000000 \
	&& npx playwright install --with-deps chromium \
	&& yarn cache clean \
	&& yarn prisma generate && yarn build

FROM gcr.io/distroless/nodejs18-debian12:nonroot
WORKDIR /data
COPY --from=1 --chown=nonroot:nonroot /data /data
COPY --from=0 /usr/local/cargo/bin/monolith /usr/local/bin/monolith
COPY --chown=nonroot:nonroot ./init.js /init.js
CMD ["/init.js"]