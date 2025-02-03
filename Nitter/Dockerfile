FROM docker.io/library/python:3-alpine
ARG UID=200013
ENV NITTER_ACCOUNTS_FILE=/data/guest_accounts.json
ENV TWITTER_CREDENTIALS_FILE=/data/twitter-credentials.json
WORKDIR /app
RUN apk --no-cache add pcre ca-certificates tini
RUN addgroup -g ${UID} nitter \
	&& adduser -g ${UID} --ingroup nitter --disabled-password --system nitter
COPY --from=ghcr.io/sekai-soft/nitter-self-contained:latest /src/scripts/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && rm -f /tmp/requirements.txt
USER nitter
COPY --chown=${UID}:${UID} --from=ghcr.io/sekai-soft/nitter-self-contained:latest /src/nitter /app/nitter
COPY --chown=${UID}:${UID} --from=ghcr.io/sekai-soft/nitter-self-contained:latest /src/public /app/public
COPY --chown=${UID}:${UID} --from=ghcr.io/sekai-soft/nitter-self-contained:latest /src/scripts/auth.py /app/auth.py
COPY --chown=${UID}:${UID} ./nitter.conf.example /app/nitter.conf
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/nitter"]