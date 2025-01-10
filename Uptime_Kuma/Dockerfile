FROM docker.io/louislam/uptime-kuma:1-alpine
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
	&& sed -i '$i /app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &' /app/extra/entrypoint.sh \
	&& sed -i '$i /app/tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=uptime-kuma' /app/extra/entrypoint.sh \
	&& sed -i '$i /app/tailscale serve 3001' /app/extra/entrypoint.sh