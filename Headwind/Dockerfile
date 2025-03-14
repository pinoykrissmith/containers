FROM docker.io/library/tomcat:9-jre11-temurin-jammy
ARG UID=200004
ENV HMDM_URL=https://h-mdm.com/files/hmdm-5.32.1-os.war
ENV CLIENT_VERSION=6.16
ENV PROTOCOL=https
ENV INSTALL_LANGUAGE=en
ENV SHARED_SECRET=changeme-C3z9vi54
ENV SQL_HOST=hmdm-postgres
ENV SQL_PORT=5432
ENV SQL_BASE=hmdm
ENV SQL_USER=hmdm
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y \
	&& apt-get install aapt wget sed postgresql-client -y \
	&& rm -rf /var/cache/apt/*

RUN --network=none mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
	&& mkdir -p /usr/local/tomcat/ssl \
	&& chown --recursive ${UID}:${UID} /usr/local/tomcat/work /usr/local/tomcat/logs /usr/local/tomcat/webapps /usr/local/tomcat/conf/Catalina/localhost /usr/local/tomcat/temp \
	&& sed -i "s|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g" /opt/java/openjdk/conf/security/java.security \
	&& addgroup --gid ${UID} --system hmdm && adduser --ingroup hmdm --uid ${UID} --disabled-password --no-create-home --shell /usr/sbin/nologin --system hmdm

COPY --from=docker.io/headwindmdm/hmdm:0.1.5 /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=docker.io/headwindmdm/hmdm:0.1.5 /opt/hmdm/ /opt/hmdm/
COPY --from=docker.io/headwindmdm/hmdm:0.1.5 /usr/local/tomcat/conf/server.xml /usr/local/tomcat/conf/server.xml
RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /usr/bin/su

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
USER ${UID}