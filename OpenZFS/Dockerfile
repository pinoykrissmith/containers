FROM docker.io/library/ubuntu:25.10
ARG VERSION=2.3.5
RUN apt-get update && apt-get install -y alien autoconf automake build-essential \
	debhelper-compat dh-autoreconf dh-dkms dh-python dkms fakeroot gawk \
	git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev \
	libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-generic \
	parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging \
	python3-setuptools python3-sphinx uuid-dev zlib1g-dev make zip gpg

WORKDIR /tmp/zfs
RUN git clone --depth=1 https://github.com/openzfs/zfs.git -b zfs-${VERSION} .
COPY signers /tmp/signers
RUN --network=none gpg --import /tmp/signers \
	&& git verify-tag $(git describe --tags) \
	&& sed -i 's/CDDL/GPL/' META \
	&& sh autogen.sh \
	&& ./configure \
	&& make native-deb-utils

WORKDIR /tmp
RUN zip debs.zip openzfs-libuutil*.deb openzfs-libnvpair*.deb openzfs-libzfs*.deb \
	openzfs-libzpool*.deb openzfs-libzfsbootenv*.deb openzfs-libpam-zfs*.deb \
	openzfs-zfsutils*.deb -x *dev*

FROM scratch
COPY --from=0 /tmp/debs.zip /install/debs.zip