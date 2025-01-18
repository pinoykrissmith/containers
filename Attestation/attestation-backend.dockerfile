FROM docker.io/library/eclipse-temurin:21-noble

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential swig git

WORKDIR /tmp/sqlite4java
RUN git clone --depth=1 https://github.com/GrapheneOS/sqlite4java.git . \
	&& sed -i "s/amd64/$(uname -m)/g" Makefile && sed -i 's/-fcf-protection//g' Makefile \
	&& sed -i 's|^JAVA_HOME := .*|JAVA_HOME := /opt/java/openjdk|' Makefile && make

WORKDIR /app
RUN git clone --depth=1 https://github.com/GrapheneOS/AttestationServer.git . \
	&& sed -i 's/::1/0.0.0.0/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/app\.attestation\.auditor/app\.selfhosted\.auditor/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& sed -i 's/"attestation.app"/System.getenv("DOMAIN") != null ? System.getenv("DOMAIN") : "attestation.app"/g' src/main/java/app/attestation/server/AttestationServer.java \
	&& sed -i 's/"990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/System.getenv("CERTIFICATE") != null ? System.getenv("CERTIFICATE") : "990E04F0864B19F14F84E0E432F7A393F297AB105A22C1E1B10B442A4A62C42C"/g' src/main/java/app/attestation/server/AttestationProtocol.java \
	&& ./gradlew build && cp /tmp/sqlite4java/out/linux-$(uname -m)/*.so libs/sqlite4java-prebuilt

FROM gcr.io/distroless/java21-debian12:nonroot

WORKDIR /data
COPY --chown=nonroot:nonroot --from=0 /app/build/libs/ /app
COPY --chown=nonroot:nonroot --from=0 /app/libs/sqlite4java-prebuilt/ /usr/lib

ENTRYPOINT [ "java", "-cp", "/app/*", "app.attestation.server.AttestationServer" ]