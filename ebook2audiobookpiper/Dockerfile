FROM docker.io/library/python:3.10-slim
ARG UID=200011
ENV LANG=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive
RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\nAPT::Acquire::Retries "20";\nAPT::Get::Assume-Yes "true";\nDpkg::Use-Pty "0";\nquiet "1";' > /etc/apt/apt.conf.d/99github \
	&& apt-get update && apt-get upgrade && apt-get dist-upgrade \
	&& apt-get install calibre ffmpeg git curl unzip \
	&& rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git . \
	&& sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8080)/' gradio_gui.py \
	&& addgroup --gid ${UID} piper && adduser --ingroup piper --uid ${UID} --disabled-password --system --home /app piper \
	&& chown --recursive piper:piper /app

COPY nltk.zip /tmp
RUN pip install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir piper-tts pydub nltk beautifulsoup4 ebooklib tqdm spacio gradio \
	&& python -m spacy download en_core_web_sm \
	&& unzip -q "/tmp/nltk.zip" -d "/tmp" \
    && rm -rf "/usr/local/lib/python3.10/site-packages/nltk" \
    && mv "/tmp/nltk" "/usr/local/lib/python3.10/site-packages/nltk"

USER piper
EXPOSE 8080
CMD ["python", "gradio_gui.py"]