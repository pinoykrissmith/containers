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

[![Build custom Headwind image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-headwind.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/headwind/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/headwind:latest
```

[![Build custom Linkwarden image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-linkwarden.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/linkwarden/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/linkwarden:latest
```

[![Build custom Nitter image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-nitter.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/nitter/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/nitter:latest
```

[![Build custom pgvecto.rs image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-pgvecto.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/pgvecto/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/pgvecto:latest
```

[![Build custom Traccar image, scan & push](https://github.com/pinoykrissmith/containers/actions/workflows/build-traccar.yml/badge.svg)](https://github.com/pinoykrissmith/containers/pkgs/container/traccar/versions?filters%5Bversion_type%5D=tagged)
```
docker pull ghcr.io/pinoykrissmith/traccar:latest
```

### Features & usage
- Rebases many images to their newer iteration if possible. Upgrade the existing if it is not.
- Ensures that the images are abled to be used unprivileged with Podman. Sets a custom UID in the Dockerfile.
- Runs secureblue's [removesuid](https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh) script when applicable.

### Licensing
- Any file that isn't a binary such as the Dockerfile and compose.yml in this repository is licensed under the WTFPL.
- Any image built by this repository is provided under the combination of license terms resulting from the use of individual packages.