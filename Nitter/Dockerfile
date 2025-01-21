ARG UID=200013
FROM docker.io/library/alpine:3.18 as nim
RUN apk --no-cache add libsass-dev pcre gcc git libc-dev "nim=1.6.14-r0" "nimble=0.13.1-r2"

WORKDIR /src/nitter
RUN git clone --depth 1 https://github.com/sekai-soft/nitter.git . \
	&& nimble install -y --depsOnly \
	&& nimble build -d:danger -d:lto -d:strip \
	&& nimble scss \
	&& nimble md

FROM docker.io/library/alpine:latest
ARG UID
ENV NITTER_ACCOUNTS_FILE=/data/guest_accounts.json
ENV TWITTER_CREDENTIALS_FILE=/data/twitter-credentials.json
WORKDIR /data
RUN apk --no-cache add pcre ca-certificates python3 py3-pip bash
RUN addgroup -g ${UID} nitter \
	&& adduser -g ${UID} --ingroup nitter --disabled-password --system nitter
COPY --from=nim /src/nitter/scripts/requirements.txt ./
RUN pip install --no-cache-dir -r ./requirements.txt --break-system-packages
USER nitter
COPY --chown=${UID}:${UID} --from=nim /src/nitter/nitter /app/nitter
COPY --chown=${UID}:${UID} --from=nim /src/nitter/public /app/public
COPY --chown=${UID}:${UID} --from=nim /src/nitter/scripts/auth.py /app/auth.py
COPY --chown=${UID}:${UID} ./nitter.conf.example /app/nitter.conf
EXPOSE 8080
CMD ["/bin/bash", "-c", "python /app/auth.py /nitter-data/guest_accounts.json && /app/nitter"]