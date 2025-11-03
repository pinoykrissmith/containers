FROM docker.io/nimlang/nim:2.2.0-alpine-regular
WORKDIR /src/
RUN apk --no-cache add libsass-dev pcre git

RUN git init . && git remote add origin https://github.com/IruzzArcana/nitter.git \
	&& git fetch --depth 1 origin 948504dfc0fe8cb5e277da3d630c951e48bfe1e1 \
	&& git checkout FETCH_HEAD
RUN nimble install -y --depsOnly \
	&& nimble build -d:danger -d:lto -d:strip --mm:refc \
	&& nimble scss \
	&& nimble md

FROM docker.io/library/alpine:latest
ARG UID=200013
ENV NITTER_SESSIONS_FILE=/data/sessions.jsonl
WORKDIR /app
RUN apk --no-cache add pcre ca-certificates openssl
RUN --network=none addgroup -g ${UID} --system nitter && adduser -u ${UID} --ingroup nitter --disabled-password -s /sbin/nologin -H --system nitter

COPY --from=0 /src/nitter /app/nitter
COPY --from=0 /src/public /app/public
COPY --chmod=644 ./nitter.conf.example /app/nitter.conf

USER nitter
EXPOSE 8080
CMD ["/app/nitter"]