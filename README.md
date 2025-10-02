# Images
[![Build custom Archiveteam image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-archiveteam.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/archiveteam/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/archiveteam:latest
```

[![Build custom Attestation image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-attestation.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/attestation/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/attestation:latest
```

[![Build custom Caddy image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-caddy.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/caddy/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/caddy:latest
```

[![Build custom ebook2audiobookpiper image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-ebook2audiobookpiper.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/ebook2audiobookpiper/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/ebook2audiobookpiper:latest
```

[![Build custom F-Droid image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-fdroid.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/fdroid/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/fdroid:latest
```

[![Build custom Immich Server image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-immich-server.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/immich-server/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/immich-server:latest
```

[![Build custom Immich Machine Learning image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-immich-machine-learning.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/immich-machine-learning/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/immich-machine-learning:latest
```

[![Build custom Linkwarden image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-linkwarden.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/linkwarden/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/linkwarden:latest
```

[![Build custom Nitter image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-nitter.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/nitter/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/nitter:latest
```

[![Build custom VectorChord image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-vectorchord.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/vectorchord/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/vectorchord:latest
```

[![Build custom Traccar image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-traccar.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/traccar/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/traccar:latest
```

### Features & usage
- Rebases many images to their newer iteration if possible. Upgrade the existing if it is not.
- Ensures that the images are abled to be used unprivileged with Podman. Sets a custom UID in the Dockerfile.
- Removed SUID and SGID bits in images.

### Licensing
- Any file that isn't a binary such as the Dockerfile and compose.yml in this repository is licensed under the WTFPL.
- Any image built by this repository is provided under the combination of license terms resulting from the use of individual packages.