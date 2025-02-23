FROM registry.fedoraproject.org/fedora:latest
ARG UID=200011
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SHARE="False"
ENV GRADIO_ANALYTICS_ENABLED="False"
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=8080
RUN sed -i -e s,countme=1,countme=0, /etc/yum.repos.d/*.repo \
	&& dnf install -y --setopt=install_weak_deps=False calibre ffmpeg git python3.10 which \
	&& dnf clean all -y

WORKDIR /app
ADD --chown=${UID}:${UID} https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git#main .
RUN --network=none groupadd -g ${UID} -r piper && useradd -u ${UID} -r -M -g piper -s /usr/sbin/nologin piper

ADD --chmod=755 https://github.com/secureblue/secureblue/raw/681a8c1a8fa77f401be5d117babbda44fdd142ad/files/scripts/removesuid.sh /tmp/
RUN --network=none /tmp/removesuid.sh || true && rm /tmp/removesuid.sh

RUN python3.10 -m ensurepip --upgrade && pip3.10 install --no-cache-dir --upgrade pip \
	&& pip3.10 install --no-cache-dir --prefer-binary spacy==3.7.5 piper-tts pydub nltk beautifulsoup4 ebooklib tqdm gradio \
	&& python3.10 -m spacy download en_core_web_sm \
	&& python3.10 -m nltk.downloader -d "/usr/share/nltk_data" punkt

USER ${UID}
EXPOSE 8080
CMD ["python3.10", "gradio_gui.py"]