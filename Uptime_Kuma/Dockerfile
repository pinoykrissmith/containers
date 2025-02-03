FROM docker.io/library/python:3.11
RUN apt-get update && apt-get install -y git
WORKDIR /src
RUN git clone https://github.com/YoRyan/mailrise.git -b 1.4.0 .
RUN pip install --user --no-cache-dir --no-warn-script-location .

FROM docker.io/louislam/uptime-kuma:beta-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:/opt/mailrise/bin:${PATH}"
ENV GIN_MODE=release
ENV MODE=normal
ENV AUTO_RECEIVE_SCHEDULE="0 22 * * *"
ENV PYTHONPATH=/opt/mailrise/lib/python3.11/site-packages
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /opt/ /opt/
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /usr/bin/signal-cli-rest-api /usr/bin/signal-cli-rest-api
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /usr/bin/jsonrpc2-helper /usr/bin/jsonrpc2-helper
COPY --from=docker.io/library/eclipse-temurin:21-jre $JAVA_HOME $JAVA_HOME
COPY --from=0 --chown=node:node /root/.local/ /opt/mailrise
COPY ./supervisord.conf /etc/supervisord.conf
RUN curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).noarmor.gpg" | tee /usr/share/keyrings/tailscale-archive-keyring.gpg \
	&& curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).tailscale-keyring.list" | tee /etc/apt/sources.list.d/tailscale.list \
	&& apt-get purge -y cloudflared && rm -f /etc/apt/sources.list.d/cloudflared.list \
	&& apt-get update && apt-get -y upgrade && apt-get install -y ca-certificates iptables tailscale supervisor python3 && rm -rf /var/cache/apt/*
RUN ln -s /opt/signal-cli-*/bin/signal-cli /usr/bin/signal-cli \
	&& ln -s /opt/signal-cli-*/bin/signal-cli-native /usr/bin/signal-cli-native
CMD ["/usr/bin/supervisord"]