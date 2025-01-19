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
	&& sed -i -e '/repo_url/d' -e '/archive_url/d' /usr/local/lib/python*/dist-packages/fdroidserver/common.py \
	&& rm -rf /var/cache/apt/*
RUN printf '#!/bin/sh\njava -jar /usr/lib/android-sdk/build-tools/debian/apksigner.jar "$@"' > /usr/local/bin/apksigner \
	&& chmod +x /usr/local/bin/apksigner
RUN wget -qO /download.py https://gitlab.com/CalyxOS/calyxos-fdroid-repo/-/raw/99d7f16b53bf55b76bedc15985da1f1da7084c2b/download.py
RUN printf "worker_processes  auto;\npid        /tmp/nginx.pid;\nevents {\n    worker_connections  1024;\n}\n\nhttp {\n    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n    server {\n        listen 8080;\n        port_in_redirect off;\n        absolute_redirect off;\n        root /fdroid;\n        location / {\n            return 403;\n        }\n        location /repo {\n            try_files \$uri \$uri/ =404;\n        }\n    }\n    include /etc/nginx/conf.d/*.conf;\n}\n" > /etc/nginx/nginx.conf \
	&& chown nginx:nginx /etc/nginx/nginx.conf
RUN printf '#!/bin/sh\n/usr/local/bin/fdroid update -v' > /docker-entrypoint.d/99-fdroid-update.sh \
	&& chmod +x /docker-entrypoint.d/99-fdroid-update.sh
RUN printf "#!/bin/bash\nfor apk in repo/*.apk; do\n    if [[ -f \"\$apk\" ]]; then\n        json=\$(androguard apkid \"\$apk\")\n        package_name=\$(echo \"\$json\" | sed -n '3p' | tr -d '\",' | xargs)\n        if [[ -n \"\$package_name\" && ! -f \"metadata/\$package_name.yml\" ]]; then\n            rm \"\$apk\"\n        fi\n    fi\ndone\n" > /usr/local/bin/cleanup \
	&& chmod +x /usr/local/bin/cleanup
USER nginx
WORKDIR /fdroid
RUN printf '\n---\nsdk_path: /usr/lib/android-sdk\nrepo_url: {env: REPO_URL}\nrepo_name: {env: REPO_NAME}\nrepo_keyalias: host.containers.internal\nkeystore: /keystore.p12\nkeystorepass: {env: KEYSTOREPASS}\nkeypass: {env: KEYPASS}\nkeydname: CN=host.containers.internal, OU=F-Droid' > config.yml \
	&& chmod 0600 config.yml