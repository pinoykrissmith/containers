FROM docker.io/opensuse/tumbleweed:latest
ARG UID=200011
RUN zypper -n update \
	&& zypper -n install calibre ffmpeg git unzip python310 tini \
	&& rm -rf /var/cache/zypp/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8080)/' gradio_gui.py \
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
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["python3.10", "-u", "gradio_gui.py"]