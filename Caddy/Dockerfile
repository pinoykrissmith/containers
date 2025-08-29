FROM docker.io/library/golang:1
ARG VERSION=2.10.2
ENV GO111MODULE=on \
	CGO_ENABLED=0
RUN go run github.com/caddyserver/xcaddy/cmd/xcaddy@latest build v${VERSION} --output /usr/bin/caddy \
	--with github.com/caddy-dns/cloudflare@8cbec3f04d5b4a768c52941a5468c4b71436509e \
	--with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5 \
	--with github.com/caddyserver/transform-encoder@47f376e021efdfdf2d47ca716c8f031b4fdfad92 \
	--with github.com/tailscale/caddy-tailscale@fd3f49d73216641b9cbe9167bbb05250c0ffc6d6 \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http@28ef1be0db6542a5efd451009c72ec419b815faa

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