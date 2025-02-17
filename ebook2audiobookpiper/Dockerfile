FROM registry.fedoraproject.org/fedora:latest
ARG UID=200011
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SHARE="False"
ENV GRADIO_ANALYTICS_ENABLED="False"
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=8080
RUN sed -i -e s,countme=1,countme=0, /etc/yum.repos.d/*.repo \
	&& dnf install --skip-broken -y --setopt=install_weak_deps=False calibre ffmpeg unzip git python3.10 which \
	&& dnf remove sudo -y --setopt protected_packages= \
	&& dnf clean all

WORKDIR /app
ADD https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git#main .
RUN useradd -u ${UID} -r -d /app -s /sbin/nologin piper \
	&& chown --recursive piper:piper /app

COPY nltk.zip /tmp
RUN python3.10 -m ensurepip --upgrade && pip3.10 install --no-cache-dir --upgrade pip \
	&& pip3.10 install --no-cache-dir --prefer-binary spacy==3.7.5 piper-tts pydub nltk beautifulsoup4 ebooklib tqdm gradio \
	&& python3.10 -m spacy download en_core_web_sm \
	&& unzip -q "/tmp/nltk.zip" -d "/tmp" \
	&& rm -rf "/usr/local/lib/python3.10/site-packages/nltk" "/tmp/nltk.zip" \
	&& mv "/tmp/nltk" "/usr/local/lib/python3.10/site-packages/nltk"

USER piper
EXPOSE 8080
CMD ["python3.10", "gradio_gui.py"]