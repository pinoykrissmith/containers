ARG VERSION=6.6
FROM docker.io/traccar/traccar:${VERSION}-debian
FROM gcr.io/distroless/java-base-debian12:nonroot
ENV JAVA_HOME=/opt/java/openjdk
ENV CONFIG_USE_ENVIRONMENT_VARIABLES=true
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV DATABASE_DRIVER="org.postgresql.Driver"
ENV DATABASE_URL="jdbc:postgresql://traccar_postgresql/postgres"
ENV POSTGRES_USER="traccar-admin"
WORKDIR /app
COPY --from=docker.io/library/eclipse-temurin:17-jre $JAVA_HOME $JAVA_HOME
COPY --from=0 /opt/traccar /app

USER 200018
EXPOSE 8082
CMD ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "conf/traccar.xml"]