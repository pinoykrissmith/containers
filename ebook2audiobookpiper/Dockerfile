FROM docker.io/library/python:3.10-slim
ARG UID=200011
ENV LANG=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive
RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\nAPT::Acquire::Retries "20";\nAPT::Get::Assume-Yes "true";\nDpkg::Use-Pty "0";\nquiet "1";' > /etc/apt/apt.conf.d/99github \
	&& apt-get update && apt-get upgrade && apt-get dist-upgrade \
	&& apt-get install calibre ffmpeg git curl \
	&& rm -rf /var/cache/apt/*

RUN curl -sSL https://github.com/DrewThomasson/ebook2audiobookpiper-tts/raw/8284918b7ae5d563f0c4d5b42abd0f6402190156/requirements.txt | grep -Ev 'nvidia|triton' | pip install --no-cache-dir -r /dev/stdin \
	&& python -m spacy download en_core_web_sm

WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8080)/' gradio_gui.py \
	&& chown --recursive ${UID}:${UID} /app \
	&& addgroup --gid ${UID} piper \
	&& adduser --ingroup piper --uid ${UID} --disabled-password --system --home /app piper

USER piper
EXPOSE 8080
CMD ["python", "gradio_gui.py"]