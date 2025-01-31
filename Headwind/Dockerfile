FROM docker.io/library/tomcat:9-jdk11-temurin-jammy
ARG UID=3006
ENV LANG=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive

RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\nAPT::Acquire::Retries "20";\nAPT::Get::Assume-Yes "true";\nDpkg::Use-Pty "0";\nquiet "1";' > /etc/apt/apt.conf.d/99github \
	&& apt-get update && apt-get upgrade && apt-get dist-upgrade \
	&& apt-get install aapt wget sed postgresql-client \
	&& rm -rf /var/cache/apt/*
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost
RUN mkdir -p /usr/local/tomcat/ssl

# Set to 1 to force updating the config files
# If not set, they will be created only if there's no files
#ENV FORCE_RECONFIGURE=true
ENV FORCE_RECONFIGURE=

# Available values: en, ru (en by default)
ENV INSTALL_LANGUAGE=en

#ENV ADMIN_EMAIL=

# Different for open source and premium versions!
ENV SHARED_SECRET=changeme-C3z9vi54

ENV HMDM_VARIANT=os
ENV DOWNLOAD_CREDENTIALS=
ENV HMDM_URL=https://h-mdm.com/files/hmdm-5.30.3-$HMDM_VARIANT.war
ENV CLIENT_VERSION=6.14

ENV SQL_HOST=localhost
ENV SQL_PORT=5432
ENV SQL_BASE=hmdm
ENV SQL_USER=hmdm
ENV SQL_PASS=Ch@nGeMe

ENV PROTOCOL=https
#ENV BASE_DOMAIN=your-domain.com

# Set this parameter to your local IP address 
# if your server is behind the NAT
#ENV LOCAL_IP=172.31.91.82

# Comment it to use custom certificates
ENV HTTPS_LETSENCRYPT=false
# Mount the custom certificate path if custom certificates must be used
# ENV_HTTPS_CERT_PATH is the path to certificates and keys inside the container
#ENV HTTPS_CERT_PATH=/cert
ENV HTTPS_CERT=cert.pem
ENV HTTPS_FULLCHAIN=fullchain.pem
ENV HTTPS_PRIVKEY=privkey.pem

RUN chown --recursive ${UID}:${UID} /usr/local/tomcat/ \
    && chown --recursive ${UID}:${UID} /opt/ \
    && addgroup --gid ${UID} hmdm \
    && adduser --ingroup hmdm --uid ${UID} --disabled-password --system hmdm

EXPOSE 8080
EXPOSE 8443
EXPOSE 31000

COPY --from=docker.io/headwindmdm/hmdm:latest /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=docker.io/headwindmdm/hmdm:latest --chown=${UID}:${UID} /opt/hmdm/ /opt/hmdm/

ENTRYPOINT ["/docker-entrypoint.sh"]
USER hmdm