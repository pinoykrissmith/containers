FROM docker.io/opensuse/tumbleweed:latest
ARG UID=200011
RUN zypper -n update \
	&& zypper -n install calibre ffmpeg git unzip python310 tini \
	&& rm -rf /var/cache/zypp/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& useradd -u ${UID} -r -d /app -s /sbin/nologin piper \
	&& chown --recursive piper:piper /app

COPY nltk.zip /tmp
RUN python3.10 -m ensurepip --upgrade && pip3.10 install --no-cache-dir --upgrade pip \
	&& pip3.10 install --no-cache-dir --prefer-binary spacy==3.7.5 piper-tts pydub nltk beautifulsoup4 ebooklib tqdm gradio \
	&& python3.10 -m spacy download en_core_web_sm \
	&& unzip -q "/tmp/nltk.zip" -d "/tmp" \
	&& rm -rf "/usr/local/lib/python3.10/site-packages/nltk" \
	&& mv "/tmp/nltk" "/usr/local/lib/python3.10/site-packages/nltk"

USER piper
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SHARE="False"
ENV GRADIO_ANALYTICS_ENABLED="False"
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=8080
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["python3.10", "gradio_gui.py"]