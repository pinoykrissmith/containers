FROM docker.io/louislam/uptime-kuma:beta-slim

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV GIN_MODE=release
ENV MODE=native
ENV AUTO_RECEIVE_SCHEDULE="0 22 * * *"
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /opt/ /opt/
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /usr/bin/signal-cli-rest-api /usr/bin/signal-cli-rest-api
COPY ./supervisord.conf /etc/supervisord.conf
RUN curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).noarmor.gpg" | tee /usr/share/keyrings/tailscale-archive-keyring.gpg \
	&& curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).tailscale-keyring.list" | tee /etc/apt/sources.list.d/tailscale.list \
	&& apt-get purge -y cloudflared && rm -f /etc/apt/sources.list.d/cloudflared.list \
	&& apt-get update && apt-get -y upgrade && apt-get install -y ca-certificates iptables tailscale supervisor && rm -rf /var/cache/apt/*
RUN ln -s /opt/signal-cli-*/bin/signal-cli-native /usr/bin/signal-cli-native
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]