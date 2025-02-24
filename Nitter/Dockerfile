FROM docker.io/library/alpine:3.20.6
WORKDIR /src/
ADD --keep-git-dir=true https://github.com/zedeus/nitter.git#master .
RUN apk --no-cache add libsass-dev pcre gcc git libc-dev nim nimble
RUN nimble install -y --depsOnly \
	&& nimble build -d:danger -d:lto -d:strip --mm:refc \
	&& nimble scss \
	&& nimble md

FROM docker.io/library/python:3-alpine
ARG UID=200013
ENV NITTER_SESSIONS_FILE=/data/sessions.jsonl
WORKDIR /app
RUN apk --no-cache add pcre ca-certificates openssl
RUN pip install --no-cache-dir pyotp requests
RUN --network=none addgroup -g ${UID} --system nitter && adduser -u ${UID} --ingroup nitter --disabled-password -s /sbin/nologin -H --system nitter

USER ${UID}
COPY --chown=${UID}:${UID} --from=0 /src/nitter /app/nitter
COPY --chown=${UID}:${UID} --from=0 /src/public /app/public
COPY --chown=${UID}:${UID} --from=0 /src/tools/get_session.py /app/get_session.py
COPY --chown=${UID}:${UID} ./nitter.conf.example /app/nitter.conf
EXPOSE 8080
CMD ["/app/nitter"]