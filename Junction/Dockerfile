ARG VERSION=1.7.1
ARG PYTHON=3.11
FROM docker.io/library/golang:bookworm
WORKDIR /app
ADD https://github.com/kenneth-church/junction.git#main .
RUN go install .
RUN apt-get update && apt-get install -y tini

FROM docker.io/library/python:${PYTHON}-slim
ARG VERSION
WORKDIR /root/.local/bin
RUN pip install --upgrade pip && pip install --user apprise==${VERSION}
RUN sed -i 's|/usr/local/bin/python3.11|/usr/bin/python|g' *

FROM gcr.io/distroless/python3-debian12:nonroot
ARG PYTHON
ENV PATH="/app:${PATH}"
ENV PYTHONPATH=/usr/local/lib/python${PYTHON}/site-packages
WORKDIR /app
COPY --from=0 /go/bin/junction /app/junction
COPY --from=0 /usr/bin/tini /usr/bin/tini
COPY --from=0 /usr/bin/tini-static /usr/bin/tini-static
COPY --from=1 /root/.local/bin/apprise /app/apprise
COPY --from=1 /root/.local/bin/markdown_py /app/markdown_py
COPY --from=1 /root/.local/bin/normalizer /app/normalizer
COPY --from=1 /root/.local/lib/python${PYTHON}/site-packages/ /usr/local/lib/python${PYTHON}/site-packages/
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/app/junction"]