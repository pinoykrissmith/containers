FROM docker.io/library/eclipse-temurin:17-noble
RUN $JAVA_HOME/bin/jlink \
	--add-modules java.base,java.compiler,java.datatransfer,java.desktop,java.instrument,java.logging,java.management,java.naming,java.net.http,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.transaction.xa,java.xml,jdk.attach,jdk.jdi,jdk.net,jdk.sctp,jdk.unsupported \
	--strip-debug --no-man-pages --no-header-files --compress=2 --output /javaruntime

FROM gcr.io/distroless/java-base-debian12:nonroot
WORKDIR /home/nonroot/traccar
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=0 /javaruntime $JAVA_HOME
COPY --chown=nonroot:nonroot --from=docker.io/traccar/traccar:debian /opt/traccar /home/nonroot/traccar
EXPOSE 8082
ENTRYPOINT ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true"]
CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]