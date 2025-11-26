FROM docker.io/library/golang:1
ARG VERSION=2.10.2
ENV GO111MODULE=on \
	CGO_ENABLED=0
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@2fc25ee62f40fe21b240f83ab2fb6e2be6dbb953 \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/tailscale/caddy-tailscale@662ef34c64b102e9a23da608a663bc65f7202ace

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