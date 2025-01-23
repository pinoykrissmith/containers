FROM docker.io/library/python:3.10-slim-bookworm
ARG UID=200011

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y calibre ffmpeg git unzip curl tini \
	&& rm -rf /var/cache/apt/*

RUN pip install --no-cache-dir --upgrade pip \
	&& curl -sSL https://github.com/DrewThomasson/ebook2audiobookpiper-tts/raw/8284918b7ae5d563f0c4d5b42abd0f6402190156/requirements.txt | grep -Ev 'nvidia|triton' | pip install --no-cache-dir -r /dev/stdin \
	&& python -m spacy download en_core_web_sm

COPY nltk.zip /tmp
RUN unzip -q "/tmp/nltk.zip" -d "/tmp" \
	&& rm -rf "/usr/local/lib/python3.10/site-packages/nltk" \
	&& mv "/tmp/nltk" "/usr/local/lib/python3.10/site-packages/nltk"

RUN mkdir /app \
	&& chown --recursive ${UID}:${UID} /app \
	&& addgroup --gid ${UID} piper \
	&& adduser --ingroup piper --uid ${UID} --disabled-password --system --home /app piper

USER piper
WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8081)/' gradio_gui.py

EXPOSE 8081
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/python", "/app/gradio_gui.py"]