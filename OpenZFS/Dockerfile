FROM registry.fedoraproject.org/fedora:41
ARG VERSION=2.3.1
RUN sed -i -e s,countme=1,countme=0, /etc/yum.repos.d/*.repo \
	&& dnf install --skip-broken gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
	libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel python3 \
	python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel \
	dnf-plugins-core dkms python3-packaging -y \
	&& dnf copr enable @asahi/kernel -y \
	&& dnf install kernel-16k-devel -y

WORKDIR /tmp/zfs
RUN git clone --depth=1 https://github.com/openzfs/zfs.git -b zfs-${VERSION} .
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