FROM docker.io/nimlang/nim:2.2.0-alpine-regular
WORKDIR /src/
RUN apk --no-cache add libsass-dev pcre git

RUN git init . && git remote add origin https://github.com/pinoykrissmith/nitter.git \
	&& git fetch --depth 1 origin 68da4197a38d351fa2941287005c93918bbc7515 \
	&& git checkout FETCH_HEAD
RUN nimble install -y --depsOnly \
	&& nimble build -d:danger -d:lto -d:strip --mm:refc \
	&& nimble scss \
	&& nimble md

FROM docker.io/library/python:3-alpine
ARG UID=200013
ENV NITTER_SESSIONS_FILE=/data/sessions.jsonl
WORKDIR /app
RUN apk --no-cache add pcre ca-certificates openssl
RUN pip install --no-cache-dir nodriver>=0.48.0 pyotp curl_cffi requests cloudscraper
RUN --network=none addgroup -g ${UID} --system nitter && adduser -u ${UID} --ingroup nitter --disabled-password -s /sbin/nologin -H --system nitter

COPY --from=0 /src/nitter /app/nitter
COPY --from=0 /src/public /app/public
COPY --from=0 /src/tools/get_session.py /app/get_session.py
COPY --from=0 /src/tools/create_session_browser.py /app/create_session_browser.py
COPY --from=0 /src/tools/create_session_curl.py /app/create_session_curl.py
COPY --chmod=644 ./nitter.conf.example /app/nitter.conf

USER nitter
EXPOSE 8080
CMD ["/app/nitter"]