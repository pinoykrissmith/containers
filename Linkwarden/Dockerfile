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

FROM docker.io/library/rust:1-bookworm
RUN cargo install --locked monolith && strip --strip-all /usr/local/cargo/bin/monolith

FROM gcr.io/distroless/nodejs22-debian12:nonroot
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /data
COPY --from=0 --chown=nonroot:nonroot /data /data
COPY --from=1 /usr/local/cargo/bin/monolith /usr/local/bin/monolith
COPY --chmod=644 ./init.js /init.js
EXPOSE 3000
CMD ["/init.js"]