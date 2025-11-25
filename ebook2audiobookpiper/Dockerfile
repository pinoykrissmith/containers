FROM registry.fedoraproject.org/fedora:latest
ARG UID=200011
ENV PYTHONUNBUFFERED=1 \
	GRADIO_SHARE="False" \
	GRADIO_ANALYTICS_ENABLED="False" \
	GRADIO_SERVER_NAME=0.0.0.0 \
	GRADIO_SERVER_PORT=8080
RUN sed -i -e s,countme=1,countme=0, /etc/yum.repos.d/*.repo \
	&& dnf install -y --setopt=install_weak_deps=False calibre ffmpeg git python3.10 which \
	&& dnf clean all -y

WORKDIR /app
ADD --chown=${UID}:${UID} https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git#main .
RUN --network=none groupadd -g ${UID} -r piper && useradd -u ${UID} -r -M -g piper -s /usr/sbin/nologin piper

RUN python3.10 -m ensurepip --upgrade && pip3.10 install --no-cache-dir --upgrade pip \
	&& pip3.10 install --no-cache-dir --prefer-binary spacy piper-tts pydub nltk beautifulsoup4 ebooklib tqdm gradio==5.30.0 \
	&& python3.10 -m spacy download en_core_web_sm \
	&& python3.10 -m nltk.downloader -d "/usr/share/nltk_data" punkt

RUN --network=none find /usr -type f -perm /4000 -exec chmod u-s {} \; && find /usr -type f -perm /2000 -exec chmod g-s {} \; \
	&& rm -f /usr/bin/chsh /usr/bin/pkexec /usr/bin/sudo /usr/bin/su

USER piper
EXPOSE 8080
CMD ["python3.10", "gradio_gui.py"]