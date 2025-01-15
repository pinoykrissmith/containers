ARG VERSION=2.8.4
FROM docker.io/library/caddy:${VERSION} as caddy
FROM docker.io/library/golang:1.22 AS builder
ARG VERSION
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/caddyserver/transform-encoder@47f376e021efdfdf2d47ca716c8f031b4fdfad92 \
	--with github.com/tailscale/caddy-tailscale@f21c01b660c896bdd6bacc37178dc00d9af282b4 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@28ef1be0db6542a5efd451009c72ec419b815faa

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=builder /usr/bin/caddy /caddy
COPY --from=caddy /etc/caddy/Caddyfile /etc/caddy/Caddyfile
COPY --from=caddy /usr/share/caddy/index.html /usr/share/caddy/index.html
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data
EXPOSE 443
EXPOSE 443/udp
CMD ["/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]