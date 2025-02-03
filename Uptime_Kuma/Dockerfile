ARG PYTHON=3.11
FROM docker.io/library/golang:bookworm
WORKDIR /app
ADD https://github.com/kenneth-church/junction.git#main .
RUN go install .

FROM docker.io/library/python:${PYTHON}-slim
WORKDIR /root/.local/bin
RUN pip install --upgrade pip && pip install --user apprise==1.7.1
RUN sed -i 's|/usr/local/bin/python3.11|/usr/bin/python|g' *

FROM docker.io/louislam/uptime-kuma:beta-slim
ARG PYTHON
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:/app:${PATH}"
ENV GIN_MODE=release
ENV MODE=normal
ENV AUTO_RECEIVE_SCHEDULE="0 22 * * *"
ENV PYTHONPATH=/usr/local/lib/python${PYTHON}/site-packages
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /opt/ /opt/
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /usr/bin/signal-cli-rest-api /usr/bin/signal-cli-rest-api
COPY --from=docker.io/bbernhard/signal-cli-rest-api:latest /usr/bin/jsonrpc2-helper /usr/bin/jsonrpc2-helper
COPY --from=docker.io/library/eclipse-temurin:21-jre $JAVA_HOME $JAVA_HOME
COPY --from=0 /go/bin/junction /app/junction
COPY --from=1 /root/.local/bin/apprise /app/apprise
COPY --from=1 /root/.local/bin/markdown_py /app/markdown_py
COPY --from=1 /root/.local/bin/normalizer /app/normalizer
COPY --from=1 /root/.local/lib/python${PYTHON}/site-packages/ /usr/local/lib/python${PYTHON}/site-packages/
COPY ./supervisord.conf /etc/supervisord.conf
RUN curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).noarmor.gpg" | tee /usr/share/keyrings/tailscale-archive-keyring.gpg \
	&& curl -fsSL "https://pkgs.tailscale.com/stable/debian/$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).tailscale-keyring.list" | tee /etc/apt/sources.list.d/tailscale.list \
	&& apt-get purge -y cloudflared && rm -f /etc/apt/sources.list.d/cloudflared.list \
	&& apt-get update && apt-get -y upgrade && apt-get install -y ca-certificates iptables tailscale supervisor && rm -rf /var/cache/apt/*
RUN ln -s /opt/signal-cli-*/bin/signal-cli /usr/bin/signal-cli \
	&& ln -s /opt/signal-cli-*/bin/signal-cli-native /usr/bin/signal-cli-native
CMD ["/usr/bin/supervisord"]