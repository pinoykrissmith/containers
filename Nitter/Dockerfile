FROM docker.io/library/debian:bookworm as nim
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y libsass-dev libpcre3 build-essential git nim \
	&& cp -L /usr/lib/$(uname -m)-linux-gnu/libpcre.so.3 /libpcre.so.3

WORKDIR /src/nitter
RUN git clone --depth 1 https://github.com/sekai-soft/nitter.git . \
	&& nimble install -y --depsOnly \
	&& nimble build -d:danger -d:lto -d:strip \
	&& nimble scss \
	&& nimble md

FROM gcr.io/distroless/cc-debian12:nonroot
WORKDIR /app
ENV NITTER_ACCOUNTS_FILE=/nitter-data/guest_accounts.json
COPY --from=nim /libpcre.so.3 /usr/lib/libpcre.so.3
COPY --chown=nonroot:nonroot --from=nim /src/nitter/nitter ./
COPY --chown=nonroot:nonroot --from=nim /src/nitter/public ./public
COPY --chown=nonroot:nonroot ./nitter.conf.example ./nitter.conf
EXPOSE 8080
CMD ["/app/nitter"]