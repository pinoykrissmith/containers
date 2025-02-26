FROM docker.io/library/tomcat:9-jdk11-temurin-jammy
ARG UID=200004
ENV HMDM_URL=https://h-mdm.com/files/hmdm-5.32.1-os.war
ENV CLIENT_VERSION=6.16
ENV PROTOCOL=https
ENV INSTALL_LANGUAGE=en
ENV SHARED_SECRET=changeme-C3z9vi54
ENV SQL_PORT=5432
ENV SQL_BASE=hmdm
ENV SQL_USER=hmdm
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
	&& apt-get install aapt wget sed postgresql-client -y \
	&& rm -rf /var/cache/apt/*

RUN --network=none mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
	&& mkdir -p /usr/local/tomcat/ssl \
	&& chown --recursive ${UID}:${UID} /usr/local/tomcat/work /usr/local/tomcat/logs \
	&& sed -i "s|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g" /opt/java/openjdk/conf/security/java.security \
	&& addgroup --gid ${UID} --system hmdm && adduser --ingroup hmdm --uid ${UID} --disabled-password --no-create-home --shell /usr/sbin/nologin --system hmdm

COPY --from=docker.io/headwindmdm/hmdm:0.1.5 /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=docker.io/headwindmdm/hmdm:0.1.5 --chown=${UID}:${UID} /opt/hmdm/ /opt/hmdm/
COPY --from=docker.io/headwindmdm/hmdm:0.1.5 --chown=${UID}:${UID} /usr/local/tomcat/conf/server.xml /usr/local/tomcat/conf/server.xml
ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN --network=none /tmp/removesuid.sh || true && rm /tmp/removesuid.sh
EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
USER ${UID}