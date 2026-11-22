FROM docker.io/library/rust:1-alpine
WORKDIR /src/
RUN apk --no-cache add build-base cmake git

ADD --keep-git-dir=true https://github.com/4cuck/teapawt.git .
RUN cargo build --release && cargo build --release --locked --bin teapot --bin import-accounts

FROM docker.io/library/alpine:latest
ARG UID=200013
ENV TEAPOT_CONF_FILE=/app/teapot.toml \
	TEAPOT_SESSIONS_FILE=/app/sessions.jsonl \
	TEAPOT_SESSION_STATE_FILE=/app/cache/session-limits.json \
	TEAPOT_GRAPHQL_OPS_FILE=/app/cache/graphql-ops.json \
	TEAPOT_LIMITS_DATABASE_URL="host=nitter-postgres port=5432 user=teapot password=teapot dbname=teapot" \
	TEAPOT_STATS_DATABASE_URL="host=nitter-postgres port=5432 user=teapot password=teapot dbname=teapot"

WORKDIR /app
RUN apk --no-cache add pcre ca-certificates openssl ffmpeg
RUN --network=none addgroup -g ${UID} --system nitter && adduser -u ${UID} --ingroup nitter --disabled-password -s /sbin/nologin -H --system nitter

COPY --from=0 /src/target/release/teapot /app/teapot
COPY --from=0 /src/target/release/import-accounts /usr/local/bin/import-accounts
COPY --from=0 /src/public /app/public
COPY --from=0 /src/config/teapot.example.toml  /app/teapot.toml

USER nitter
EXPOSE 8080
CMD ["/app/teapot"]