FROM docker.io/library/golang:1.22 AS builder
ARG VERSION=2.8.4
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/caddyserver/transform-encoder@47f376e021efdfdf2d47ca716c8f031b4fdfad92 \
	--with github.com/tailscale/caddy-tailscale@f21c01b660c896bdd6bacc37178dc00d9af282b4 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@187784279826178d11bb26e7f0b7cd86aae052b9 # For compatibility with Tailscale

FROM docker.io/curlimages/curl:latest as curl
RUN curl -sL -o /tmp/Caddyfile https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/config/Caddyfile \
	&& curl -sL -o /tmp/index.html https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/welcome/index.html

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=builder /usr/bin/caddy /caddy
COPY --from=curl /tmp/Caddyfile /etc/caddy/Caddyfile
COPY --from=curl /tmp/index.html /usr/share/caddy/index.html
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data
EXPOSE 443
EXPOSE 443/udp
WORKDIR /srv
CMD ["/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]