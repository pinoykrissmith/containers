FROM docker.io/library/golang:1
ARG VERSION=2.11.2
ENV GO111MODULE=on \
	CGO_ENABLED=0
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@a8737d095ad5a48ca031cea6ab704057dbc2d250 \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/tailscale/caddy-tailscale@de41b249af4fd2083612c3b2303197e92787d1c5

FROM scratch
ENV XDG_CONFIG_HOME=/config \
	XDG_DATA_HOME=/data
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=0 /usr/bin/caddy /usr/bin/caddy

USER 200017
EXPOSE 443
EXPOSE 443/udp
CMD ["/usr/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]