FROM docker.io/curlimages/curl:latest as curl
ENV TRACCAR_VERSION 6.5
RUN curl -sL -o /tmp/traccar.zip https://github.com/traccar/traccar/releases/download/v$TRACCAR_VERSION/traccar-other-$TRACCAR_VERSION.zip
RUN unzip -qo /tmp/traccar.zip -d /tmp/traccar

FROM gcr.io/distroless/java17-debian12:nonroot
WORKDIR /home/nonroot/traccar
COPY --chown=nonroot:nonroot --from=curl /tmp/traccar /home/nonroot/traccar
ENTRYPOINT ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true"]
CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]