FROM gcr.io/distroless/java-base-debian12:nonroot
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=docker.io/library/eclipse-temurin:17-jre $JAVA_HOME $JAVA_HOME
COPY --chown=nonroot:nonroot --from=docker.io/traccar/traccar:debian /opt/traccar /home/nonroot/traccar
EXPOSE 8082
WORKDIR /home/nonroot/traccar
CMD ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "conf/traccar.xml"]