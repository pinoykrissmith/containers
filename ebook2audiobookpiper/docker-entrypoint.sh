#!/bin/bash

if [ -z "$(ls -A /app/)" ]; then
    git clone --depth 1 https://github.com/DrewThomasson/ebook2audiobookpiper-tts.git /app/
    sed -i 's/demo\.launch(share=True)/demo.launch(server_name="0.0.0.0", server_port=7860)/' /app/gradio_gui.py
    python Auto_download_all_piper_models.py
fi
exec "$@"