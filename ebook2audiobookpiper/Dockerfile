FROM docker.io/library/python:3.10-slim
ARG UID=3009

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y calibre ffmpeg git unzip \
	&& rm -rf /var/cache/apt/*

RUN pip install --no-cache-dir --upgrade pip \
	&& curl -sSL https://github.com/DrewThomasson/ebook2audiobookpiper-tts/raw/8284918b7ae5d563f0c4d5b42abd0f6402190156/requirements.txt | pip install - \
	&& python -m spacy download en_core_web_sm

COPY nltk.zip /tmp
RUN unzip -q "/tmp/nltk.zip" -d "/tmp" \
	&& rm -rf "/usr/local/lib/python3.10/site-packages/nltk" \
	&& mv "/tmp/nltk" "/usr/local/lib/python3.10/site-packages/nltk"

RUN mkdir /app \
	&& chown --recursive ${UID}:${UID} /app \
	&& addgroup --gid ${UID} piper \
	&& adduser --ingroup piper --uid ${UID} --disabled-password --system piper

COPY docker-entrypoint.sh /
USER piper
WORKDIR /app

EXPOSE 7860
CMD ["python", "/app/gradio_gui.py"]
ENTRYPOINT ["/docker-entrypoint.sh"]