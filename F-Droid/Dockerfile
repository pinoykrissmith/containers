FROM ghcr.io/nginxinc/nginx-unprivileged:stable-bookworm
USER root
ARG VERSION=2.3.4
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive
RUN echo Etc/UTC > /etc/timezone \
	&& echo 'APT::Install-Recommends "0";' \
		'APT::Install-Suggests "0";' \
		'APT::Acquire::Retries "20";' \
		'APT::Get::Assume-Yes "true";' \
		'Dpkg::Use-Pty "0";' \
		'quiet "1";' \
        >> /etc/apt/apt.conf.d/99fdroid

RUN apt-get update \
	&& apt-get upgrade \
	&& apt-get dist-upgrade \
	&& apt-get install apksigner git lzip openjdk-17-jdk-headless python3 python3-pip wget \
	&& pip install --no-cache-dir --break-system-packages \
		git+https://github.com/androguard/androguard@16a6bd21946bfe3d75639ffd3d96957971b6553f \
		git+https://gitlab.com/fdroid/fdroidserver@$VERSION \
	&& rm -rf /var/cache/apt/*
RUN printf '#!/bin/sh\njava -jar /usr/lib/android-sdk/build-tools/debian/apksigner.jar "$@"' > /usr/local/bin/apksigner \
	&& chmod +x /usr/local/bin/apksigner
RUN sed -i -e '/repo_url/d' -e '/archive_url/d' /usr/local/lib/python*/dist-packages/fdroidserver/common.py
RUN wget -qO /download.py https://gitlab.com/CalyxOS/calyxos-fdroid-repo/-/raw/99d7f16b53bf55b76bedc15985da1f1da7084c2b/download.py
COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
RUN printf '#!/bin/sh\n/usr/local/bin/fdroid update\n' > /docker-entrypoint.d/40-fdroid-update.sh
RUN chmod +x /docker-entrypoint.d/40-fdroid-update.sh
USER nginx
WORKDIR /fdroid
RUN printf "---\nsdk_path: /usr/lib/android-sdk\nrepo_url: {env: REPO_URL}\nrepo_name: {env: REPO_NAME}\nrepo_keyalias: host.containers.internal\nkeystore: /keystore.p12\nkeystorepass: {env: KEYSTOREPASS}\nkeypass: {env: KEYPASS}\nkeydname: CN=host.containers.internal, OU=F-Droid" > config.yml