FROM docker.io/louislam/uptime-kuma:1 as malloc
ARG VERSION=2024101200
RUN apt-get update && apt-get install -y build-essential git openssh-client gnupg
WORKDIR /malloc
RUN git clone https://github.com/GrapheneOS/hardened_malloc.git -b ${VERSION} . \
	&& curl -sL -o signers https://grapheneos.org/allowed_signers
RUN --network=none \
    git config gpg.ssh.allowedSignersFile signers \
    && git verify-tag $(git describe --tags) \
    && make CONFIG_NATIVE=false VARIANT=default

FROM docker.io/louislam/uptime-kuma:1
COPY --from=malloc /malloc/out/libhardened_malloc.so /usr/local/lib/libhardened_malloc.so
RUN curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).noarmor.gpg" | tee /usr/share/keyrings/tailscale-archive-keyring.gpg \
	&& curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).tailscale-keyring.list" | tee /etc/apt/sources.list.d/tailscale.list \
	&& apt-get purge -y cloudflared && rm -f /etc/apt/sources.list.d/cloudflared.list \
	&& apt-get update && apt-get -y upgrade && apt-get install -y ca-certificates iptables tailscale && rm -rf /var/cache/apt/*
RUN sed -i '$i tailscaled --state=/app/data/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &' /app/extra/entrypoint.sh \
	&& sed -i '$i tailscale up --auth-key="${TAILSCALE_AUTHKEY}?ephemeral=true&preauthorized=true" --advertise-tags=tag:untrusted --hostname=uptime-kuma' /app/extra/entrypoint.sh
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"