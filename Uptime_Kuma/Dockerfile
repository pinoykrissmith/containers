FROM docker.io/louislam/uptime-kuma:1
RUN curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).noarmor.gpg" | tee /usr/share/keyrings/tailscale-archive-keyring.gpg \
	&& curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).tailscale-keyring.list" | tee /etc/apt/sources.list.d/tailscale.list \
	&& apt-get purge -y cloudflared && rm -f /etc/apt/sources.list.d/cloudflared.list \
	&& apt-get update && apt-get -y upgrade && apt-get install -y ca-certificates iptables tailscale && rm -rf /var/cache/apt/*
RUN sed -i '$i tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &' /app/extra/entrypoint.sh \
	&& sed -i '$i tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=uptime-kuma' /app/extra/entrypoint.sh
	&& sed -i '$i tailscale serve --https=8081 http://127.0.0.1:3001/' /app/extra/entrypoint.sh