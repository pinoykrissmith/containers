ARG VERSION=2.9.1
FROM docker.io/library/golang:1
ARG VERSION
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/caddyserver/transform-encoder@47f376e021efdfdf2d47ca716c8f031b4fdfad92 \
	--with github.com/tailscale/caddy-tailscale@fd3f49d73216641b9cbe9167bbb05250c0ffc6d6 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@28ef1be0db6542a5efd451009c72ec419b815faa

FROM docker.io/library/caddy:${VERSION}
FROM scratch
ARG UID=200017
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /usr/share/zoneinfo /usr/share/zoneinfo
COPY --chown=${UID}:${UID} --from=0 /usr/bin/caddy /usr/bin/caddy
COPY --chown=${UID}:${UID} --from=1 /etc/caddy/Caddyfile /etc/caddy/Caddyfile
COPY --chown=${UID}:${UID} --from=1 /usr/share/caddy/index.html /usr/share/caddy/index.html
USER ${UID}
EXPOSE 443
EXPOSE 443/udp
CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]