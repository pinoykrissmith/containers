FROM docker.io/library/tomcat:9-jdk11-temurin-jammy
ARG UID=3006
ENV DEBIAN_FRONTEND=noninteractive
ENV INSTALL_LANGUAGE=en
ENV SHARED_SECRET=changeme-C3z9vi54
ENV HMDM_VARIANT=os
ENV HMDM_URL=https://h-mdm.com/files/hmdm-5.30.3-$HMDM_VARIANT.war
ENV CLIENT_VERSION=6.14
ENV SQL_HOST=localhost
ENV SQL_PORT=5432
ENV SQL_BASE=hmdm
ENV SQL_USER=hmdm
ENV SQL_PASS=Ch@nGeMe
ENV PROTOCOL=https
ENV HTTPS_CERT=cert.pem
ENV HTTPS_FULLCHAIN=fullchain.pem
ENV HTTPS_PRIVKEY=privkey.pem
RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\nAPT::Acquire::Retries "20";\nAPT::Get::Assume-Yes "true";\nDpkg::Use-Pty "0";\nquiet "1";' > /etc/apt/apt.conf.d/99github \
	&& apt-get update && apt-get upgrade && apt-get dist-upgrade \
	&& apt-get install aapt wget sed postgresql-client \
	&& rm -rf /var/cache/apt/*

RUN --network=none mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
	&& mkdir -p /usr/local/tomcat/ssl \
	&& chown --recursive ${UID}:${UID} /usr/local/tomcat/ \
	&& chown --recursive ${UID}:${UID} /opt/ \
	&& addgroup --gid ${UID} --system hmdm \
	&& adduser --ingroup hmdm --uid ${UID} --disabled-password --no-create-home --shell /usr/sbin/nologin --system hmdm

COPY --from=docker.io/headwindmdm/hmdm:latest /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=docker.io/headwindmdm/hmdm:latest --chown=${UID}:${UID} /opt/hmdm/ /opt/hmdm/
EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
USER ${UID}