FROM docker.io/library/python:3.10-slim
ARG UID=3009
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y calibre ffmpeg git unzip \
	&& rm -rf /var/cache/apt/*

RUN pip install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir piper-tts==1.2.0 pydub==0.25.1 nltk==3.9.1 beautifulsoup4==4.12.3 ebooklib==0.18 tqdm==4.67.1 spacy==3.8.3 gradio==5.11.0 \
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