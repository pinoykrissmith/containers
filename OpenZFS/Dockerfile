FROM docker.io/library/fedora:41
ARG VERSION=2.3.0
RUN dnf upgrade --refresh -y --setopt=installonly_limit=0 \
	&& dnf install --skip-broken gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
	libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel python3 \
	python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel \
	dnf-plugins-core dkms python3-packaging -y --setopt=installonly_limit=0 \
	&& dnf copr enable @asahi/kernel -y \
	&& dnf install kernel-16k-devel -y --setopt=installonly_limit=0

WORKDIR /tmp/zfs
RUN git clone --depth=1 https://github.com/openzfs/zfs.git#zfs-$VERSION .
COPY signers /tmp/signers
RUN --network=none gpg --import /tmp/signers \
	&& git verify-tag $(git describe --tags) \
	&& sed -i 's/kernel-devel/kernel-16k-devel/g' rpm/generic/zfs-dkms.spec.in \
	&& sh autogen.sh \
	&& ./configure \
	&& make -j$(nproc) rpm-utils rpm-dkms \
	&& zip rpms.zip *.rpm -x '*src*.rpm'

FROM scratch
USER 3005
COPY --from=0 /tmp/zfs/rpms.zip /install/rpms.zip