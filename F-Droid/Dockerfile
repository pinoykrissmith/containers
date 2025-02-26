FROM docker.io/nginxinc/nginx-unprivileged:stable-bookworm
USER root
ARG VERSION=2.3.5
ARG UID=200008
WORKDIR /fdroid
ADD --chmod=644 https://gitlab.com/CalyxOS/calyxos-fdroid-repo/-/raw/99d7f16b53bf55b76bedc15985da1f1da7084c2b/download.py /download.py
RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\nAPT::Acquire::Retries "20";\nAPT::Get::Assume-Yes "true";\nDpkg::Use-Pty "0";\nquiet "1";' > /etc/apt/apt.conf.d/99github \
	&& apt-get update && apt-get upgrade && apt-get dist-upgrade \
	&& apt-get install apksigner git lzip openjdk-17-jdk-headless python3 python3-pip wget \
	&& rm -rf /var/cache/apt/*
RUN pip install --no-cache-dir --break-system-packages \
		git+https://github.com/androguard/androguard@16a6bd21946bfe3d75639ffd3d96957971b6553f \
		git+https://gitlab.com/fdroid/fdroidserver@$VERSION \
	&& sed -i -e '/repo_url/d' -e '/archive_url/d' /usr/local/lib/python*/dist-packages/fdroidserver/common.py
RUN --network=none printf '#!/bin/sh\njava -jar /usr/lib/android-sdk/build-tools/debian/apksigner.jar "$@"' > /usr/local/bin/apksigner && chmod +x /usr/local/bin/apksigner \
	&& printf "worker_processes  auto;\npid        /tmp/nginx.pid;\nevents {\n    worker_connections  1024;\n}\n\nhttp {\n    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n    server {\n        listen 8080;\n        port_in_redirect off;\n        absolute_redirect off;\n        root /fdroid;\n        location / {\n            return 403;\n        }\n        location /repo {\n            try_files \$uri \$uri/ =404;\n        }\n    }\n    include /etc/nginx/conf.d/*.conf;\n}\n" > /etc/nginx/nginx.conf && chmod 644 /etc/nginx/nginx.conf \
	&& printf '#!/bin/sh\n/usr/local/bin/fdroid update -v' > /docker-entrypoint.d/99-fdroid-update.sh && chmod +x /docker-entrypoint.d/99-fdroid-update.sh \
	&& printf "#!/bin/bash\nfor apk in repo/*.apk; do\n    if [[ -f \"\$apk\" ]]; then\n        json=\$(androguard apkid \"\$apk\")\n        package_name=\$(echo \"\$json\" | sed -n '3p' | tr -d '\",' | xargs)\n        if [[ -n \"\$package_name\" && ! -f \"metadata/\$package_name.yml\" ]]; then\n            rm \"\$apk\"\n        fi\n    fi\ndone\n" > /usr/local/bin/cleanup && chmod +x /usr/local/bin/cleanup \
	&& printf '\n---\nsdk_path: /usr/lib/android-sdk\nrepo_url: {env: REPO_URL}\nrepo_name: {env: REPO_NAME}\nrepo_keyalias: host.containers.internal\nkeystore: /keystore.p12\nkeystorepass: {env: KEYSTOREPASS}\nkeypass: {env: KEYPASS}\nkeydname: CN=host.containers.internal, OU=F-Droid' > /fdroid/config.yml && chown ${UID}:${UID} /fdroid/config.yml && chmod 0600 /fdroid/config.yml
RUN --network=none usermod -u ${UID} nginx && groupmod -g ${UID} nginx \
	&& find / -path /proc -prune -o -user 101 -exec chown nginx {} + && find / -path /proc -prune -o -group 101 -exec chgrp nginx {} +
ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN --network=none /tmp/removesuid.sh || true && rm /tmp/removesuid.sh
USER ${UID}