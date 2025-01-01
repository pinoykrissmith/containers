ARG UID=3004
FROM docker.io/library/alpine:3.18 as nim

RUN apk --no-cache add libsass-dev pcre gcc git libc-dev "nim=1.6.14-r0" "nimble=0.13.1-r2"

WORKDIR /src/nitter

RUN git clone --depth 1 https://github.com/sekai-soft/nitter.git .
RUN nimble install -y --depsOnly

COPY . .
RUN nimble build -d:danger -d:lto -d:strip \
    && nimble scss \
    && nimble md

FROM docker.io/library/alpine:latest
ARG UID
WORKDIR /app
RUN apk --no-cache add pcre ca-certificates bash python3 py3-pip
RUN addgroup -g ${UID} nitter \
    && adduser -g ${UID} --ingroup nitter --disabled-password --system nitter
COPY --from=nim /src/nitter/scripts/requirements.txt ./
RUN pip install -r ./requirements.txt --break-system-packages

USER nitter
COPY --chown=${UID}:${UID} --from=nim /src/nitter/nitter ./
COPY --chown=${UID}:${UID} --from=nim /src/nitter/public ./public
COPY --chown=${UID}:${UID} --from=nim /src/nitter/scripts/auth.py ./
EXPOSE 8081
CMD ["/bin/bash", "-c", "python /app/auth.py /nitter-data/guest_accounts.json && /app/nitter"]