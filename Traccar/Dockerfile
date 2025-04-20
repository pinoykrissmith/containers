FROM docker.io/library/alpine:latest
ARG VERSION=6.6
ARG UID=200018
ENV CONFIG_USE_ENVIRONMENT_VARIABLES=true \
	DATABASE_DRIVER="org.postgresql.Driver" \
	DATABASE_URL="jdbc:postgresql://traccar_postgresql/postgres" \
	DATABASE_USER="traccar-admin"
WORKDIR /app

RUN apk add --no-cache openjdk17-jre-headless curl \
	&& curl -Lo /tmp/traccar.zip https://github.com/traccar/traccar/releases/download/v${VERSION}/traccar-other-${VERSION}.zip \
	&& unzip -qo /tmp/traccar.zip -d /app \
	&& rm /tmp/traccar.zip \
	&& apk del curl

RUN --network=none addgroup -g ${UID} --system traccar && adduser -u ${UID} --ingroup traccar --disabled-password -s /sbin/nologin -H --system traccar

USER traccar
EXPOSE 8082
CMD ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "conf/traccar.xml"]