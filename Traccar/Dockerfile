
FROM docker.io/library/debian:bookworm
RUN apt-get update && apt-get install -y tini

FROM gcr.io/distroless/java-base-debian12:nonroot
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=docker.io/library/eclipse-temurin:17-jre-noble $JAVA_HOME $JAVA_HOME
COPY --chown=nonroot:nonroot --from=docker.io/traccar/traccar:debian /opt/traccar /home/nonroot/traccar
COPY --from=0 /usr/bin/tini /usr/bin/tini
COPY --from=0 /usr/bin/tini-static /usr/bin/tini-static
EXPOSE 8082
WORKDIR /home/nonroot/traccar
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "conf/traccar.xml"]