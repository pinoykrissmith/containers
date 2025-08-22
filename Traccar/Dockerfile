FROM docker.io/library/eclipse-temurin:21-alpine
RUN jlink --module-path $JAVA_HOME/jmods \
	--add-modules java.se,jdk.charsets,jdk.crypto.ec,jdk.unsupported \
	--strip-debug --no-header-files --no-man-pages --compress=2 --output /javaruntime

FROM docker.io/library/alpine:latest
ARG VERSION=6.9.1
ARG UID=200018
ENV CONFIG_USE_ENVIRONMENT_VARIABLES=true \
	DATABASE_DRIVER="org.postgresql.Driver" \
	DATABASE_URL="jdbc:postgresql://traccar_postgresql/postgres" \
	DATABASE_USER="traccar-admin" \
	JAVA_HOME=/opt/java/openjdk \
	PATH="/opt/java/openjdk/bin:$PATH"
WORKDIR /app
COPY --from=0 /javaruntime $JAVA_HOME

RUN apk add --no-cache java-common java-cacerts curl \
	&& curl -Lo /tmp/traccar.zip https://github.com/traccar/traccar/releases/download/v${VERSION}/traccar-other-${VERSION}.zip \
	&& unzip -qo /tmp/traccar.zip -d /app \
	&& rm /tmp/traccar.zip \
	&& apk del curl

RUN --network=none addgroup -g ${UID} --system traccar && adduser -u ${UID} --ingroup traccar --disabled-password -s /sbin/nologin -H --system traccar

USER traccar
EXPOSE 8082
CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]