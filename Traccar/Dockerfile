FROM gcr.io/distroless/java17-debian12:nonroot
WORKDIR /home/nonroot/traccar
COPY --chown=nonroot:nonroot --from=docker.io/traccar/traccar:debian /opt/traccar /home/nonroot/traccar
ENTRYPOINT ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true"]
CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]