FROM docker.io/library/caddy:2.8.4-builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/tailscale/caddy-tailscale \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http@main \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4@main

FROM docker.io/curlimages/curl:latest as curl
RUN curl -sL -o /tmp/Caddyfile https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/config/Caddyfile
RUN curl -sL -o /tmp/index.html https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/welcome/index.html

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