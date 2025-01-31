ARG VERSION=2.3.0
ARG UID=3005
ARG FEDORA=41

FROM docker.io/library/fedora:${FEDORA}
ARG UID
ARG VERSION
RUN useradd -u ${UID} -r -d /install -s /sbin/nologin builder \ 
	&& mkdir /install \
	&& chown builder:builder /install

RUN dnf upgrade --refresh -y --setopt=installonly_limit=0 \ 
	&& dnf install --skip-broken gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
	libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel python3 \
	python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel \
	dnf-plugins-core dkms python3-packaging -y --setopt=installonly_limit=0 \
	&& dnf copr enable @asahi/kernel -y \
	&& dnf install kernel-16k-devel -y --setopt=installonly_limit=0 \
	&& rm -rf /var/cache/dnf/*

USER builder
RUN git clone https://github.com/openzfs/zfs.git --depth 1 --branch zfs-${VERSION} /tmp/zfs
COPY --chown=${UID}:${UID} signers /tmp/signers

RUN --network=none cd /tmp/zfs \
	&& gpg --import /tmp/signers \
	&& git verify-tag $(git describe --tags) \
	&& sed -i 's/kernel-devel/kernel-16k-devel/g' rpm/generic/zfs-dkms.spec.in \
	&& sh autogen.sh \
	&& ./configure \
	&& make -j$(nproc) rpm-utils rpm-dkms \
	&& zip /install/rpms.zip *.rpm -x '*src*.rpm'