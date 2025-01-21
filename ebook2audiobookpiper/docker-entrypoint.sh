#!/bin/bash
if [ -z "$(ls -A /app/)" ]; then
    git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git .
    sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=8080)/' gradio_gui.py
fi
exec "$@"