FROM docker.io/library/debian:bookworm
RUN apt-get update && apt-get install -y tini

FROM gcr.io/distroless/java17-debian12:nonroot
WORKDIR /home/nonroot/traccar
COPY --chown=nonroot:nonroot --from=docker.io/traccar/traccar:debian /opt/traccar /home/nonroot/traccar
COPY --from=1 /usr/bin/tini /usr/bin/tini
COPY --from=1 /usr/bin/tini-static /usr/bin/tini-static
EXPOSE 8082
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "conf/traccar.xml"]