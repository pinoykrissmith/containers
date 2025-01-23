FROM docker.io/library/debian:bookworm
ARG UID=200011
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y calibre ffmpeg git unzip curl python3-pip \
	&& rm -rf /var/cache/apt/*

RUN curl -sSL https://github.com/DrewThomasson/ebook2audiobookpiper-tts/raw/8284918b7ae5d563f0c4d5b42abd0f6402190156/requirements.txt | grep -Ev 'nvidia|triton' | pip3 install --break-system-packages --no-cache-dir -r /dev/stdin \
	&& python3 -m spacy download en_core_web_sm

RUN mkdir /app \
	&& chown --recursive ${UID}:${UID} /app \
	&& addgroup --gid ${UID} piper \
	&& adduser --ingroup piper --uid ${UID} --disabled-password --system --home /app piper

USER piper
WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8080)/' gradio_gui.py

EXPOSE 8080
CMD ["/usr/bin/python3 /app/gradio_gui.py"]