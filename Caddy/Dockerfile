FROM docker.io/library/golang:1 AS builder
ARG VERSION=2.8.4
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
    --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/vrischmann/caddy-tailscale@5c87406e645f1134b9bac872fb11e399b216e59d \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http@3ce8c4270a94f3432a00f487f9321796f3a39e10 \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4@082b2264776041afbe913e7047ab356f7689f671

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